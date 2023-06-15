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

  def handle_event({:READY, _data, _ws_state}) do
    Logger.info("Starting bot.")
    Api.update_status(:idle, "starting to spin", 0)

    # Find a way to parse the commands to maps so we only have to use Api.bulk_overwrite_X_application_commands
    # to register commands instead of the register_commands loop

    Logger.info("Registering commands.")

    case Application.fetch_env(:joel, :guild_id) do
      {:ok, value} ->
        if value != nil do
          check_guild_commands(value)
        else
          check_global_commands(:global)
        end

      :error ->
        check_global_commands(:global)
    end

    Api.update_status(:online, "funky town", 2)
    Logger.info("Bot started.")
  end

  def handle_event(_event) do
    :noop
  end

  def check_guild_commands(guild_id) do
    case Api.get_guild_application_commands(Me.get().id, guild_id) do
      {:ok, commands} ->
        # Deleting old guild commands
        if length(commands) != map_size(@commands) do
          Logger.info("Overwriting guild commands.")
          Api.bulk_overwrite_guild_application_commands(Me.get().id, guild_id, [])
        end

        register_commands(guild_id)

      error ->
        Logger.error("Error retrieving guild commands. #{error}")
    end
  end

  def check_global_commands(scope) do
    case Api.get_global_application_commands(Me.get().id) do
      {:ok, commands} ->
        # Deleting old global commands
        if length(commands) != map_size(@commands) do
          Logger.info("Overwriting global commands.")
          Api.bulk_overwrite_global_application_commands(Me.get().id, [])
        end

        register_commands(scope)

      error ->
        Logger.error("Error retrieving global commands. #{error}")
    end
  end

  def register_commands(scope) do
    Enum.each(@commands, fn {name, cog} ->
      case Nosedrum.Interactor.Dispatcher.add_command(name, cog, scope) do
        {:ok, _} ->
          Logger.info("Registered '#{name}' command.")

        {:error, reason} ->
          Logger.error("An error occurred registering '#{name}' command: #{reason}")
      end

      # Sleeping because this sometimes returns a rate limit error.
      Process.sleep(1500)
    end)
  end
end
