defmodule DoroWeb.PlayerChannel do
  use Phoenix.Channel

  def join("player:debug", _params, socket) do
    {:ok, socket}
  end

  def handle_in("cmd", %{"cmd" => cmd, "player" => player}, socket) do
    broadcast(socket, "output", %{body: "#{player} sent: '#{cmd}'"})
    {:noreply, socket}
  end
end
