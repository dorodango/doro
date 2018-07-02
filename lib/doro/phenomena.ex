defmodule Doro.Phenomena do
  @moduledoc """
  Functions for running autonomous behaviors that effect changes in the
  game state without any player interaction
  """

  require Logger
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: :phenomena)
  end

  def init(args) do
    Phoenix.PubSub.subscribe(Doro.PubSub, "heartbeat")
    {:ok, args}
  end

  def handle_info({:heartbeat, t}, state) do
    [
      Doro.Behaviors.Clock,
      Doro.Behaviors.VascularPlant
    ]
    |> Enum.each(fn phenom ->
      Task.start(fn -> phenom.tick(t) end)
    end)

    {:noreply, state}
  end
end
