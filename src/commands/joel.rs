use crate::check_msg;
use rand::Rng;
use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;
use std::{env, fs, path::PathBuf};

#[command]
#[only_in(guilds)]
async fn joel(ctx: &Context, msg: &Message) -> CommandResult {
    let folder = env::var("IMAGES_FOLDER").unwrap();

    let paths = fs::read_dir(&folder).unwrap();

    let mut images = vec![];

    for path in paths {
        let path = path.unwrap().path();
        images.push(path.to_owned());
    }

    let n = {
        let mut rng = rand::thread_rng();
        rng.gen_range(1..images.len())
    };

    let image = PathBuf::from(format!("{folder}/{n}.gif"));

    check_msg(
        msg.channel_id
            .send_message(&ctx.http, |m| m.add_file(&image))
            .await,
    );

    Ok(())
}
