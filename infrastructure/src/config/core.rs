use crate::telegram::ChatId;
use serde::{Deserialize, Serialize};
use std::collections::HashSet;

#[derive(Debug, Default, Serialize, Deserialize)]
pub struct Config {
    telegram_token: String,
    allowed_chat_ids: HashSet<ChatId>,
}

impl Config {
    pub fn telegram_token(&self) -> &str {
        &self.telegram_token
    }

    pub fn allowed_chat_ids(&self) -> &HashSet<ChatId> {
        &self.allowed_chat_ids
    }

    pub fn set_telegram_token(&mut self, token: impl Into<String>) {
        self.telegram_token = token.into();
    }

    pub fn add_allowed_chat_id(&mut self, id: ChatId) -> bool {
        self.allowed_chat_ids.insert(id)
    }

    pub fn remove_allowed_chat_id(&mut self, id: ChatId) {
        self.allowed_chat_ids.remove(&id);
    }

    pub fn is_allowed_chat_id(&self, id: ChatId) -> bool {
        self.allowed_chat_ids.contains(&id)
    }
}
