defmodule Joel.Consumer do
  @moduledoc false
  alias Nostrum.Cache.Me
  alias Nostrum.Api

  use Nostrum.Consumer

  require Logger

  @commands %{
    "ttj" => Joel.Commands.TTJ,
    "joel" => Joel.Commands.Joel,
    "play" => Joel.Commands.Play,
    "stop" => Joel.Commands.Stop,
    "pause" => Joel.Commands.Pause,
    "resume" => Joel.Commands.Resume,
    "leave" => Joel.Commands.Leave
  }

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Logger.info("#{interaction.user.username} used '#{interaction.data.name}' command.")
    Nosedrum.Interactor.Dispatcher.handle_interaction(interaction)
  end

  def handle_event({:VOICE_SPEAKING_UPDATE, payload, _ws_state}) do
    Logger.debug("VOICE_SPEAKING_UPDATE: #{inspect(payload)}")
  end

  def handle_event({:MESSAGE_CREATE, message, _ws_state}) do
    # Check if the user is not a bot and the message starts with a mention of Joel
    if !message.author.bot && String.starts_with?(message.content, "<@#{Me.get().id}>") do
      # React to the message
      Api.create_reaction(message.channel_id, message.id, "fish")

      message.content
      # Replace mention from message
      |> String.replace_prefix("<@#{Me.get().id}>", "Joel")
      # Send the message content to the local llama.cpp server
      |> Intelligence.send_message()
      |> case do
        {:ok, response} ->
          Api.create_message(
            message.channel_id,
            content: response,
            message_reference: %{message_id: message.id}
          )

        {:error, reason} ->
          Api.create_message(
            message.channel_id,
            content: "Error :fish:",
            message_reference: %{message_id: message.id}
          )

          Logger.error(reason)
      end
    end
  end

  def handle_event({:READY, _data, _ws_state}) do
    Logger.info("Starting bot.")
    Api.update_status(:idle, "starting to spin", 0)

    Logger.info("Registering commands.")

    Enum.each(@commands, fn {name, cog} ->
      case Nosedrum.Interactor.Dispatcher.add_command(name, cog, :global) do
        {:ok, _} ->
          Logger.info("Registered '#{name}' command.")

        {:error, reason} ->
          Logger.error("An error occurred registering '#{name}' command: #{reason}")
      end

      # Sleeping because this sometimes returns a rate limit error.
      Process.sleep(1500)
    end)

    Api.update_status(:online, "funky town", 2)
    Logger.info("Bot started.")
  end

  def handle_event(_event) do
    :noop
  end
end
