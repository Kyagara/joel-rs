defmodule Joel.Commands.Pause do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  require Logger

  @impl true
  def description() do
    "Pauses music."
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    if Voice.ready?(interaction.guild_id) do
      if Voice.get_current_url(interaction.guild_id) != nil &&
           Voice.playing?(interaction.guild_id) do
        Voice.pause(interaction.guild_id)
        [content: "Paused spinning."]
      else
        [content: "Nothing to pause."]
      end
    end
  end
end
