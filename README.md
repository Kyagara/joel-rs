## joel

A very simple Discord music bot.

This bot was created with the intent of just playing around with ~~Rust~~ Elixir, it lacks a lot of features. The main purpose with this is to just play music for a small server with friends and post JOEL whenever He is needed. It also sends @mentions to a llama.cpp server to get a response.

Don't actually use this. It serves no purpose.

## Slash commands

`joel`, `ttj`, `play`, `stop`, `pause`, `resume`, `leave`

## Requirements

Install `yt-dlp`, `ffmpeg`, Elixir >= 1.15.

Invite the bot with application command permission, message content gateway intent enabled.

```bash
mix deps.get
DISCORD_TOKEN=TOKEN MIX_ENV=prod mix release
# The above will by default register the commands as global commands, to register to a guild you need to define a GUILD_ID:
GUILD_ID=ID DISCORD_TOKEN=TOKEN MIX_ENV=prod mix release
```

I use [crescent](https://github.com/Kyagara/crescent) to run the bot in the background in a VM:

```bash
cres start _build/prod/rel/joel/bin/joel -a start
```

## Todo

- More JOEL (very important)
- Maybe do things the Elixir way? The lack of return in Elixir is throwing me off
