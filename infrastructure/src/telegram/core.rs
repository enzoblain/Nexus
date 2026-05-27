use teloxide::prelude::*;
use teloxide::repl;
use tokio::sync::mpsc::Sender;
use tokio::sync::oneshot::{self, Sender as OneshotSender};

pub async fn register_allowed_users(
    token: impl Into<String>,
    tx: Sender<(ChatId, OneshotSender<bool>)>,
) -> ResponseResult<()> {
    let bot = Bot::new(token.into());

    repl(bot.clone(), move |bot: Bot, msg: Message| {
        let tx = tx.clone();

        async move {
            let (response_tx, response_rx) = oneshot::channel();
            tx.send((msg.chat.id, response_tx)).await.ok();

            match response_rx.await {
                Ok(true) => {
                    bot.send_message(msg.chat.id, "✅ You have been added to FlowPilot.")
                        .await
                        .ok();
                }
                Ok(false) => {
                    bot.send_message(msg.chat.id, "⚠️ You are already registered.")
                        .await
                        .ok();
                }
                Err(_) => {
                    bot.send_message(msg.chat.id, "❌ Internal error.")
                        .await
                        .ok();
                }
            }

            respond(())
        }
    })
    .await;

    Ok(())
}
