use crate::check_msg;
use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;

#[command]
#[only_in(guilds)]
async fn playing(ctx: &Context, msg: &Message) -> CommandResult {
    let guild = msg.guild(&ctx.cache).unwrap();

    let manager = songbird::get(ctx).await.unwrap();

    if let Some(handler) = manager.get(guild.id) {
        let handler = handler.lock().await;

        let queue = handler.queue();

        let queue_length = handler.queue().len();

        if !queue.is_empty() {
            let track = queue.current().unwrap();

            let metadata = track.metadata().clone();

            check_msg(
                msg.channel_id
                    .send_message(&ctx.http, |m| {
                        m.embed(|e| {
                            e.colour(0xfcd34d)
                                .thumbnail(metadata.thumbnail.unwrap())
                                .title(format!("Playing: {}", metadata.title.unwrap()))
                                .url(metadata.source_url.unwrap())
                                .field("Tracks in queue:", queue_length, false)
                                .footer(|f| {
                                    f.icon_url(msg.author.avatar_url().unwrap());
                                    f.text(msg.author.name.clone());
                                    f
                                })
                        })
                    })
                    .await,
            );

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
