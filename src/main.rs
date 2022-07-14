/*
Copyright © 2022 Kyagara
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

mod commands;

use std::env;

use serenity::async_trait;
use serenity::framework::standard::macros::{group, hook};
use serenity::framework::StandardFramework;
use serenity::model::gateway::Activity;
use serenity::model::gateway::Ready;
use serenity::Result as SerenityResult;
use serenity::{
    client::Context,
    model::prelude::{Message, ResumedEvent},
    prelude::{Client, EventHandler},
};

use songbird::SerenityInit;

use tracing::{debug, error, info, instrument};

use crate::commands::leave::*;
use crate::commands::pause::*;
use crate::commands::play::*;
use crate::commands::playing::*;
use crate::commands::queue::*;
use crate::commands::resume::*;
use crate::commands::skip::*;
use crate::commands::stop::*;

struct Handler;

#[async_trait]
impl EventHandler for Handler {
    async fn ready(&self, ctx: Context, ready: Ready) {
        info!("{} is connected!", ready.user.name);

        let prefix = env::var("PREFIX").unwrap();

        let msg = format!("{}play", prefix);

        ctx.set_activity(Activity::listening(msg)).await;
    }

    #[instrument(skip(self, _ctx))]
    async fn resume(&self, _ctx: Context, resume: ResumedEvent) {
        debug!("resumed; trace: {:?}", resume.trace);
    }
}

#[hook]
#[instrument]
async fn before(_: &Context, msg: &Message, command_name: &str) -> bool {
    info!("command '{}' used by '{}'", command_name, msg.author.name);

    true
}

#[group]
#[commands(play, stop, leave, skip, pause, resume, queue, playing)]
struct General;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let token = env::var("DISCORD_TOKEN").unwrap();

    let prefix = env::var("PREFIX").unwrap();

    let framework = StandardFramework::new()
        .configure(|c| c.prefix(prefix))
        .group(&GENERAL_GROUP);

    let mut client = Client::builder(&token)
        .framework(framework)
        .event_handler(Handler)
        .register_songbird()
        .await
        .unwrap();

    if let Err(why) = client.start().await {
        error!("client error: {:?}", why);
    }
}

fn check_msg(result: SerenityResult<Message>) {
    if let Err(why) = result {
        error!("error sending message: {:?}", why);
    }
}
