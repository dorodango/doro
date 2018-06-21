defmodule Doro.Context do
  alias Doro.World

  defstruct original_command: nil,
            subject: nil,
            object: nil,
            verb: nil,
            handled: false

  @doc "Creates a Context given some incoming request params"
  @spec create(String.t(), String.t(), String.t(), String.t() | nil) :: {:ok, %Doro.Context{}}
  def create(original_command, player_id, verb, object_id) do
    {
      :ok,
      %Doro.Context{
        original_command: original_command,
        subject: World.get_entity(player_id),
        object: World.get_entity(object_id) || World.get_entity(player_id),
        verb: verb
      }
    }
  end

  def location(ctx) do
    Doro.World.get_entity(ctx.subject.props.location)
  end
end
