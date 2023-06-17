defmodule Joel.Commands.Stop do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  require Logger

  @impl true
  def description() do
    "Stops playing whatever thing is playing."
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    if Voice.ready?(interaction.guild_id) do
      if Voice.playing?(interaction.guild_id) do
        Voice.stop(interaction.guild_id)
        [content: "*stops spinning*"]
      else
        [content: "There's no stopping."]
      end
    end
  end
end
