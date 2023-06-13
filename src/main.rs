use anyhow::Result;
use config::Config;
use serenity::framework::standard::macros::{group, hook};
use serenity::framework::standard::CommandError;
use serenity::framework::StandardFramework;
use serenity::Result as SerenityResult;
use serenity::{
    client::Context,
    model::prelude::Message,
    prelude::{Client, GatewayIntents},
};
use songbird::SerenityInit;
use std::env;
use tracing::{error, info};

use crate::commands::joel::*;
use crate::commands::leave::*;
use crate::commands::pause::*;
use crate::commands::play::*;
use crate::commands::playing::*;
use crate::commands::queue::*;
use crate::commands::resume::*;
use crate::commands::skip::*;
use crate::commands::stop::*;

mod commands;
mod handler;

#[group]
#[commands(joel, play, stop, leave, skip, pause, resume, queue, playing)]
struct General;

#[tokio::main]
async fn main() -> Result<()> {
    let settings = Config::builder()
        .add_source(config::File::with_name("settings.toml"))
        .build()?;

    let log_level = settings.get_string("RUST_LOG")?;
    let token = settings.get_string("DISCORD_TOKEN")?;
    let prefix = settings.get_string("PREFIX")?;
    let images = settings.get_string("IMAGES_FOLDER")?;

    env::set_var("RUST_LOG", log_level);
    env::set_var("DISCORD_TOKEN", &token);
    env::set_var("PREFIX", &prefix);
    env::set_var("IMAGES_FOLDER", &images);

    tracing_subscriber::fmt::init();

    let framework = StandardFramework::new()
        .configure(|c| c.prefix(prefix))
        .after(after_hook)
        .group(&GENERAL_GROUP);

    let intents = GatewayIntents::non_privileged() | GatewayIntents::MESSAGE_CONTENT;

    let mut client = Client::builder(&token, intents)
        .framework(framework)
        .event_handler(handler::Handler)
        .register_songbird()
        .await?;

    client.start().await?;

    Ok(())
}

#[hook]
async fn after_hook(_: &Context, msg: &Message, cmd_name: &str, error: Result<(), CommandError>) {
    info!("Command '{}' used by '{}'.", cmd_name, msg.author.name);

    if let Err(err) = error {
        error!("Error in {}: {:?}", cmd_name, err);
    }
}

fn check_msg(result: SerenityResult<Message>) {
    if let Err(err) = result {
        error!("Error sending message: {:?}", err);
    }
}
