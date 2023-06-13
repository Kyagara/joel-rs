use crate::check_msg;
use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;

#[command]
#[only_in(guilds)]
async fn queue(ctx: &Context, msg: &Message) -> CommandResult {
    let guild = msg.guild(&ctx.cache).unwrap();

    let manager = songbird::get(ctx).await.unwrap();

    if let Some(handler) = manager.get(guild.id) {
        let handler = handler.lock().await;

        let queue = handler.queue();

        if !queue.is_empty() {
            let tracks = queue.current_queue();

            let mut titles = String::new();

            for (mut index, track) in tracks.iter().enumerate() {
                index += 1;

                let meta = track.metadata().clone();

                let title = match index {
                    1 => format!("**Playing now** - {}\n", meta.title.unwrap()),
                    _ => format!("**{}** - {}\n", index, meta.title.unwrap()),
                };

                titles.push_str(title.as_str());
            }

            check_msg(msg.reply(&ctx.http, titles).await);
            return Ok(());
        }

        check_msg(msg.reply(&ctx.http, "The queue is currently empty.").await);
        return Ok(());
    }

    check_msg(
        msg.reply(&ctx.http, "Currently not connected to any channel.")
            .await,
    );

    Ok(())
}
