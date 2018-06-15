defmodule Doro.GameState do
  alias Doro.Entity

  use Agent

  def start_link() do
    Agent.start_link(&debug_state/0, name: __MODULE__)
  end

  def debug_state do
    %{
      entities: %{
        "ingar" => %Entity{id: "ingar", behaviors: ~w(visible)},
        "plant" => %Entity{
          id: "plant",
          behaviors: ~w(visible),
          props: %{description: "It is herbaceous, glabrous, and two-pinnate."}
        }
      }
    }
  end

  @doc "Gets an entity by id"
  def get_entity(id) do
    Agent.get(__MODULE__, fn state -> state.entities[id] end)
  end
end
