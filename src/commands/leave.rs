use crate::check_msg;
use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;
use tracing::error;

#[command]
#[only_in(guilds)]
async fn leave(ctx: &Context, msg: &Message) -> CommandResult {
    let guild = msg.guild(&ctx.cache).unwrap();

    let manager = songbird::get(ctx).await.unwrap();

    if let Some(_handler) = manager.get(guild.id) {
        if let Err(why) = manager.remove(guild.id).await {
            error!("error leaving the channel: {:?}", why);

            check_msg(
                msg.reply(&ctx.http, "An error occurred leaving channel.")
                    .await,
            );

            return Ok(());
        }

        check_msg(msg.reply(&ctx.http, "Left the voice channel.").await);

        return Ok(());
    }

    check_msg(
        msg.reply(ctx, "Currently not connected to any channel.")
            .await,
    );

    Ok(())
}
