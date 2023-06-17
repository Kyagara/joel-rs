## joel

A very simple Discord music bot.

This bot was created with the intent of just playing around with ~~Rust~~ Elixir, it lacks a lot of features. The main purpose with this is to just play music for a small server with friends and post JOEL whenever He is needed.

## Slash commands

`joel`, `ttj`, `play`, `stop`, `pause`, `resume`, `leave`

## Requirements

Since heroku stopped offering a free tier, you will have to use other alternatives to host this bot.

This bot requires `yt-dlp`, `ffmpeg`. Using Elixir 1.14.5 and Erlang/OTP 25.

```bash
apt install ffmpeg yt-dlp
```

Invite the bot with application command permission.

```bash
mix deps.get
```

To build the bot in release mode, you need to add the Discord Token when building:

```bash
DISCORD_TOKEN=TOKEN MIX_ENV=prod mix release
```

This command will by default register the commands as global commands, to register to a guild you need to add a GUILD_ID:

```bash
GUILD_ID=ID DISCORD_TOKEN=TOKEN MIX_ENV=prod mix release
```

I use [crescent](https://github.com/Kyagara/crescent) to run the bot in the background in a VM:

```bash
cres start _build/prod/rel/joel/bin/joel -a "start"
```

## Todo

-   More JOEL (very important)
