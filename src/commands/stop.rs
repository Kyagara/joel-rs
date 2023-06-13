use crate::check_msg;
use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;

#[command]
#[only_in(guilds)]
async fn stop(ctx: &Context, msg: &Message) -> CommandResult {
    let guild = msg.guild(&ctx.cache).unwrap();

    let manager = songbird::get(ctx).await.unwrap();

    if let Some(handler) = manager.get(guild.id) {
        let handler = handler.lock().await;

        handler.queue().stop();

        check_msg(msg.reply(&ctx.http, "Stopping track.").await);
        return Ok(());
    }

    check_msg(
        msg.reply(&ctx.http, "Currently not connected to any channel.")
            .await,
    );

    Ok(())
}
