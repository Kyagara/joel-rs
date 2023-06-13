use serenity::{
    async_trait,
    model::prelude::{Activity, Ready, ResumedEvent},
    prelude::{Context, EventHandler},
};
use std::env;
use tracing::{debug, info, instrument};

pub struct Handler;

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
        debug!("Resumed; Trace: {:?}", resume.trace);
    }
}
