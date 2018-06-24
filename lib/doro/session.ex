defmodule Doro.Session do
  @moduledoc """
  Encapsulates a player's session
  """
  require Logger
  use GenServer

  def create_session(player_id) do
    start_link(player_id, Process.whereis(server_name(player_id)))
  end

  def set_socket(session, socket) do
    GenServer.cast(session, {:set_socket, socket})
  end

  def player_input(session, s) do
    GenServer.cast(session, {:player_input, s})
  end

  defp start_link(player_id, nil) do
    Logger.info("Creating session for player #{player_id}.")
    GenServer.start_link(__MODULE__, player_id, name: server_name(player_id))
  end

  defp start_link(player_id, existing_session) do
    Logger.info("Existing session found for player #{player_id}.")
    {:ok, existing_session}
  end

  defp server_name(player_id) do
    "session-#{player_id}" |> String.to_atom()
  end

  # Callbacks
  @impl true
  def init(player_id) do
    Phoenix.PubSub.subscribe(Doro.PubSub, "player-session:#{player_id}")
    {:ok, %{player_id: player_id, socket: nil}}
  end

  @impl true
  def handle_cast({:set_socket, socket}, state) do
    {:noreply, %{state | socket: socket}}
  end

  @impl true
  def handle_cast({:player_input, s}, state) do
    Doro.CLI.interpret(state.player_id, s)
    {:noreply, state}
  end

  @doc "Handle messages for player"
  def handle_info({:send, s}, state) do
    DoroWeb.Endpoint.broadcast("player:#{state.player_id}", "output", %{body: s})
    {:noreply, state}
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end
end
