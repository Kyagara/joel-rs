import Config

config :joel,
  root_dir: File.cwd!(),
  guild_id: System.get_env("GUILD_ID") || nil

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  youtubedl: "yt-dlp",
  caches: %{
    presences: Nostrum.Cache.PresenceCache.NoOp
  },
  gateway_intents: [
    :guilds,
    :guild_voice_states
  ]

config :logger, :console, metadata: [:shard, :guild, :channel], level: :info
