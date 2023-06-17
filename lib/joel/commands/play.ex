defmodule Joel.Commands.Play do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Cache.GuildCache
  alias Nostrum.Api
  alias Nostrum.Voice

  require Logger

  @impl true
  def description() do
    "Plays a sound from a link."
  end

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "url",
        description: "Link to the sound.",
        required: true
      }
    ]
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    case get_voice_channel_of_interaction(interaction) do
      nil ->
        Api.create_interaction_response!(interaction, %{
          type: 4,
          data: %{content: "You must be in a voice channel to summon me."}
        })

      voice_channel_id ->
        Voice.join_channel(interaction.guild_id, voice_channel_id, false, true)

        [%{name: "url", value: url}] = interaction.data.options

        try_play(interaction.guild_id, url)

        Api.create_interaction_response!(interaction, %{
          type: 4,
          data: %{content: "*spins* #{url}."}
        })
    end

    []
  end

  def try_play(guild_id, url) do
    case Voice.play(guild_id, url, :ytdl) do
      {:error, _msg} ->
        Process.sleep(100)
        try_play(guild_id, url)

      _ ->
        :ok
    end
  end

  def get_voice_channel_of_interaction(interaction) do
    interaction.guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn voice_state -> voice_state.user_id == interaction.user.id end)
    |> Map.get(:channel_id)
  end
end
