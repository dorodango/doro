defmodule Doro.Transports.Slack do
  require Logger
  use WebSockex

  def start_link(_) do
    Logger.info("Starting Slack transport")
    WebSockex.start_link(rtm_url(), __MODULE__, %{})
  end

  # Websockex callback
  def handle_frame({:text, msg}, state) do
    msg
    |> Poison.decode!(keys: :atoms)
    |> incoming_event()

    {:ok, state}
  end

  # Websockex callback
  def handle_frame(_, state), do: {:ok, state}

  defp incoming_event(%{type: "message", user: slack_user_id, channel: channel, text: cmd}) do
    player = ensure_player(slack_user_id, channel)
    Doro.Transports.Slack.Session.find_or_create(player.id, channel)
    handle_command(player, cmd)
  end

  defp incoming_event(_), do: nil

  defp handle_command(player, cmd) do
    with {:ok, session} <- Doro.Session.find_or_create(player.id) do
      Doro.Session.player_input(session, cmd)
    end
  end

  defp ensure_player(slack_user_id, slack_channel) do
    entity_id = player_id(slack_user_id, slack_channel)

    case Doro.World.get_entity(entity_id) do
      nil ->
        Logger.info("Creating player with id #{entity_id} for slack user id: #{slack_user_id}")

        Doro.Entity.create(
          "_player",
          %{location: "start"},
          fn _ -> real_name(slack_user_id) end,
          entity_id
        )
        |> Doro.World.add_entity()

      player ->
        player
    end
  end

  defp player_id(slack_user_id, slack_channel) do
    "_player-slack-#{slack_user_id}/#{slack_channel}"
  end

  defp real_name(slack_user_id) do
    Doro.Utils.load_url("https://slack.com/api/users.info", %{
      token: api_key(),
      user: slack_user_id
    })
    |> Poison.decode!(keys: :atoms)
    |> get_in([:user, :real_name])
  end

  defp rtm_url do
    Doro.Utils.load_url("https://slack.com/api/rtm.connect", %{token: api_key()})
    |> Poison.decode!(keys: :atoms)
    |> Map.get(:url)
  end

  def api_key do
    Application.get_env(:doro, :slack_api_key)
  end
end
