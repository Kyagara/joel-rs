defmodule Joel.Commands.TTJ do
  @moduledoc false

  @behaviour Nosedrum.ApplicationCommand

  import Nostrum.Struct.Embed

  alias Nostrum.Api
  alias Nostrum.Util

  @impl true
  def description() do
    "Calculate Time To JOEL."
  end

  @impl true
  def type() do
    :slash
  end

  @impl true
  def command(interaction) do
    before = DateTime.utc_now()

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("MOMENT")
      |> put_image("https://media.tenor.com/ZHze27YyLIkAAAAd/joel-spinning.gif")
      |> put_footer("JOEL MOMENT")

    Api.create_interaction_response!(interaction, %{
      type: 5
    })

    time =
      DateTime.diff(
        before,
        DateTime.utc_now(),
        :millisecond
      )
      |> abs()

    shard = Util.get_all_shard_latencies()[0]

    Api.edit_interaction_response!(
      interaction,
      %{
        content: "TTJ is #{time}ms. API latency is #{shard}ms.",
        embeds: [embed]
      }
    )

    # Any way to avoid doing this?
    []
  end
end
