use crate::check_msg;
use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;
use tracing::error;

#[command]
#[only_in(guilds)]
async fn skip(ctx: &Context, msg: &Message) -> CommandResult {
    let guild = msg.guild(&ctx.cache).unwrap();

    let manager = songbird::get(ctx).await.unwrap();

    if let Some(handler) = manager.get(guild.id) {
        let handler = handler.lock().await;

        let queue = handler.queue();

        if !queue.is_empty() {
            if let Err(why) = queue.skip() {
                error!("error skipping track: {:?}", why);

                check_msg(msg.reply(&ctx.http, "Error skipping track.").await);
                return Ok(());
            }

            check_msg(msg.reply(&ctx.http, "Skipping track.").await);
            return Ok(());
        }

        check_msg(msg.reply(&ctx.http, "Not playing any tracks.").await);
        return Ok(());
    }

    check_msg(
        msg.reply(&ctx.http, "Currently not connected to any channel.")
            .await,
    );

    Ok(())
}
