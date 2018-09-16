defmodule DoroWeb.Api.EntitiesController do
  use DoroWeb, :controller

  import MapHelpers

  def index(conn, _params) do
    entities =
      Doro.World.GameState.get()
      |> Doro.World.Marshal.marshal()

    conn
    |> json(%{entities: entities})
  end

  @doc """
  Create a new entity

  Expects params at the entity level.
  e.g params = %{
    "id" => "thing",
    "name" => "the thing",
    "props" => %{
      "location" => "bathroom"
    }
    "behaviors" => [
      %{
        "type" => "visible",
        "description": "a description"
      }
    ]
  }
  """
  def create(conn, params) do
    params |>
    to_entity
    |> Doro.World.add_entity()
    |> case do
      %Doro.Entity{id: id} ->
        conn
        |> json(%{message: "created (or replaced) entity #{id}"})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "failed to create entity"})
    end
  end

  defp to_entity(params) do
    params
    |> atomize_keys
    |> Map.put(:src, nil)
    |> Doro.World.Marshal.unmarshal_entity()
  end
end
