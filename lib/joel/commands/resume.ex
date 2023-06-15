defmodule Joel.Commands.Resume do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  require Logger

  @impl true
  def description() do
    "Resume music."
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    if Voice.ready?(interaction.guild_id) do
      if Voice.get_current_url(interaction.guild_id) != nil &&
           !Voice.playing?(interaction.guild_id) do
        Voice.resume(interaction.guild_id)
        [content: "Resumed spinning."]
      else
        [content: "Nothing to resume."]
      end
    end
  end
end
