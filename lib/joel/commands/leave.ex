defmodule Joel.Commands.Leave do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Voice

  require Logger

  @impl true
  def description() do
    "My job is done."
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    if Voice.get_channel_id(interaction.guild_id) != nil do
      Voice.leave_channel(interaction.guild_id)
      [content: "*leaves*"]
    else
      [content: "Not in any voice channel."]
    end
  end
end
