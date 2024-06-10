import Config

config :joel,
  root_dir: File.cwd!(),
  guild_id: System.get_env("GUILD_ID") || nil

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  youtubedl: "yt-dlp",
  gateway_intents: [
    :guilds,
    :guild_voice_states,
    :guild_messages,
    :message_content
  ]

config :logger, :console, metadata: [:shard, :guild, :channel], level: :debug
