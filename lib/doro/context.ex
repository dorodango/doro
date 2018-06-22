defmodule Doro.Context do
  alias Doro.World

  defstruct original_command: nil,
            player: nil,
            object_id: nil,
            object: nil,
            verb: nil

  @doc "Creates a Context given some incoming request params"
  @spec create(String.t(), String.t(), String.t(), String.t() | nil) :: {:ok, %Doro.Context{}}
  def create(original_command, player_id, verb, object_id) do
    {
      :ok,
      %Doro.Context{
        original_command: original_command,
        player: find_entity_by_string(player_id),
        object_id: object_id,
        object: find_entity_by_string(object_id),
        verb: verb
      }
    }
  end

  defp find_entity_by_string(s) do
    World.get_entity(s)
  end
end
