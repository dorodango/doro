defmodule DoroWeb.Api.EntitiesController do
  use DoroWeb, :controller

  import MapHelpers

  def create(conn, params) do
    params
    |> insert_visible_behavior
    |> atomize_keys
    |> Doro.World.Marshal.unmarshal_entity()
    |> Doro.World.add_entity()
    |> case do
      %Doro.Entity{id: id} ->
        conn
        |> json(%{message: "created entity: #{id}"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "failed to create entity"})
    end
  end

  def update(conn, params) do
    Doro.World.get_entity(params["id"])
    |> Map.merge(
      params
      |> atomize_keys
      |> Doro.World.Marshal.unmarshal_entity()
    )
    |> Doro.World.add_entity()

    conn
    |> json(%{message: "updated entity #{params["id"]}"})
  end

  defp insert_visible_behavior(params) do
    behaviors =
      (["visible"] ++ [params["behaviors"]])
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.filter(& &1)

    params |> Map.put("behaviors", behaviors)
  end
end
