defmodule Doro.Session do
  @moduledoc """
  Encapsulates a player's session
  """
  require Logger
  use GenServer

  def find_or_create(player_id) do
    case Registry.lookup(Doro.Registry, session_key(player_id)) do
      [] ->
        GenServer.start_link(__MODULE__, player_id)

      [{pid, _}] ->
        {:ok, pid}
    end
  end

  def player_input(session, s) do
    GenServer.cast(session, {:player_input, s})
  end

  def session_key(player_id) do
    "session-#{player_id}"
  end

  # Callbacks
  @impl true
  def init(player_id) do
    Registry.register(Doro.Registry, session_key(player_id), player_id)
    Phoenix.PubSub.subscribe(Doro.PubSub, "player-session:#{player_id}")
    {:ok, %{player_id: player_id, socket: nil}}
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
