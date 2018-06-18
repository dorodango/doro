defmodule DoroWeb.PlayerChannel do
  require Logger
  use Phoenix.Channel

  def join("player:" <> player_id, _auth_message, socket = %{assigns: %{player_id: player_id}}) do
    Logger.info("Player(#{socket.assigns.player_id}) connected via Phoenix Channels")
    {:ok, session} = Doro.Session.create_session(player_id)
    {:ok, Phoenix.Socket.assign(socket, :session, session)}
  end

  @doc "Input coming in from a channel just gets sent to this player's session"
  def handle_in("cmd", %{"cmd" => cmd}, socket = %{assigns: %{session: session}}) do
    Doro.Session.player_input(session, cmd)
    {:noreply, socket}
  end
end
