defmodule Doro.Transports.Slack.Session do
  require Logger
  use GenServer

  def find_or_create(player_id, slack_channel) do
    case Registry.lookup(Doro.Registry, process_key(player_id)) do
      [] ->
        GenServer.start_link(__MODULE__, [player_id, slack_channel])

      [{pid, _}] ->
        {:ok, pid}
    end
  end

  defp process_key(player_id) do
    "slack-session-#{player_id}"
  end

  @impl true
  def init([player_id, slack_channel]) do
    Logger.info("Creating session for player: #{player_id}")
    Registry.register(Doro.Registry, process_key(player_id), slack_channel)
    Phoenix.PubSub.subscribe(Doro.PubSub, "player-session:#{player_id}")
    {:ok, %{player_id: player_id, slack_channel: slack_channel}}
  end

  @impl true
  @doc "Handle messages for player"
  def handle_info({:send, s}, state = %{slack_channel: channel}) do
    Doro.Utils.load_url("https://slack.com/api/chat.postMessage", %{
      token: api_key(),
      channel: channel,
      text: s
    })

    {:noreply, state}
  end

  defp api_key do
    Application.get_env(:doro, :slack_api_key)
  end
end
