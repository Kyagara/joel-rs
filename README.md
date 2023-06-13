## joel-rs

A very simple Discord music bot.

This bot was created with the intent of just playing around with Rust, it lacks a lot of features. The main purpose with this is to just play music for a small server with friends and post JOEL whenever he is needed.

## Requirements

Since heroku stopped offering a free tier, you will have to use other alternatives to host this bot. I recommend [shuttle](https://github.com/shuttle-hq/shuttle).

This bot requires `yt-dlp`, `ffmpeg` and `opus`.

```bash
apt install ffmpeg libopus-dev yt-dlp
```

Rename the `settings.toml.example` file to just `settings.toml` and edit its fields.

Enable the Message Content intent in the Discord Developer Portal.

## Todo

-   Use command slash
-   Probably another rework
-   More JOEL (very important)
