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

use serenity::framework::standard::macros::command;
use serenity::framework::standard::CommandResult;
use serenity::model::prelude::Message;
use serenity::prelude::Context;

use tracing::error;

use crate::check_msg;

#[command]
#[only_in(guilds)]
async fn pause(ctx: &Context, msg: &Message) -> CommandResult {
    let guild = msg.guild(&ctx.cache).await.unwrap();

    let manager = songbird::get(ctx).await.unwrap();

    if let Some(handler) = manager.get(guild.id) {
        let handler = handler.lock().await;

        let queue = handler.queue();

        if !queue.is_empty() {
            if let Err(why) = queue.pause() {
                error!("error pausing track: {:?}", why);

                check_msg(msg.reply(&ctx.http, "Error pausing track.").await);

                return Ok(());
            }

            check_msg(msg.reply(&ctx.http, "Track paused.").await);

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
