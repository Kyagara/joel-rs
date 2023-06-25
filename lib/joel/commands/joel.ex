defmodule Joel.Commands.Joel do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api

  import Nostrum.Struct.Embed
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
  def options() do
    [
      %{
        type: :string,
        name: "joel",
        description: "Specify a custom Joel.",
        required: false
      }
    ]
  end

  @impl true
  def command(interaction) do
    root = Application.fetch_env!(:joel, :root_dir)
    path = Path.join([root, "assets", "gifs"])
    files = Path.wildcard("#{path}/*.gif")

    if interaction.data.options != nil do
      [%{name: "joel", value: joel}] = interaction.data.options
      custom_joel = Path.join([path, "#{joel}.gif"])

      if File.exists?(custom_joel) do
        send_embed(interaction, custom_joel)
      else
        send_embed(interaction, Enum.random(files))
      end
    else
      send_embed(interaction, Enum.random(files))
    end

    []
  end

  def send_embed(interaction, image_path) do
    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("MOMENT")
      |> put_image("attachment://#{Path.basename(image_path)}")
      |> put_description(Path.basename(image_path, ".gif"))
      |> put_footer("JOEL MOMENT")

    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{
        embeds: [embed],
        files: [image_path]
      }
    })
  end
end
