defmodule DoroWeb.Api.BehaviorsController do
  use DoroWeb, :controller

  def index(conn, _params) do
    behaviors = Doro.Behavior.all_behaviors()

    behavior_shapes =
      behaviors
      |> Enum.map(& {&1.key(), (struct(&1) |> Map.drop([:__struct__]))})
      |> Enum.into(%{})

    behavior_keys =
      behaviors
      |> Enum.map(& &1.key())

    conn
    |> json(%{behaviors: behavior_keys, behavior_shapes: behavior_shapes})
  end
end
