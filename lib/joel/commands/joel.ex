defmodule Joel.Commands.Joel do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api
  alias Joel.Embeds
  require Logger

  @impl true
  def description() do
    "JOEL"
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    {embed, image_path} = Embeds.create_joel_embed()

    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{
        embeds: [embed],
        files: [image_path]
      }
    })

    []
  end
end
