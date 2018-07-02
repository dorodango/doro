defmodule Doro.Heartbeat do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: :heartbeat)
  end

  @impl true
  def init(time) do
    Logger.info("starting heartbeat server")
    schedule_heartbeat()
    {:ok, time}
  end

  @impl true
  def handle_info({:beat}, time) do
    Phoenix.PubSub.broadcast(Doro.PubSub, "heartbeat", {:heartbeat, time})
    schedule_heartbeat()
    {:noreply, time + 1}
  end

  def schedule_heartbeat do
    Process.send_after(:heartbeat, {:beat}, 1000)
  end
end
