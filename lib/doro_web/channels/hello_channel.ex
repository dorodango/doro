defmodule DoroWeb.HelloChannel do
  require Logger
  use Phoenix.Channel

  def join("hello:" <> player_name, _, socket) do
    Logger.info("Initializing Phoenix Channel for player named '#{player_name}'")
    player = Doro.World.find_or_create_player(player_name, "office")
    send(self(), {:after_join, player.id})
    {:ok, Phoenix.Socket.assign(socket, :player_id, player.id)}
  end

  def handle_info({:after_join, player_id}, socket) do
    push(socket, "player_info", %{player_id: player_id})
    {:noreply, socket}
  end
end
