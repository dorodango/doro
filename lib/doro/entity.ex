defmodule Doro.Entity do
  alias Doro.Entity

  defstruct id: nil,
            behaviors: [],
            props: %{}

  def execute_behaviors(ctx) do
    Enum.reduce(ctx.object.behaviors, ctx, fn behavior, acc -> behavior.handle(acc) end)
  end

  @doc "Returns whether or not this entity should respond to verb in this context"
  def responds_to?(entity = %Entity{}, ctx = %Doro.Context{verb: verb}) do
    behaviors(entity)
    |> Enum.any?(& &1.responds_to?(verb, ctx))
  end

  @doc "Returns the first behavior that can handle this verb in this context"
  def first_responder(entity = %Entity{}, ctx = %Doro.Context{verb: verb}) do
    behaviors(entity)
    |> Enum.find(& &1.responds_to?(verb, ctx))
  end

  @doc "Returns all behaviors for this entity"
  def behaviors(entity = %Entity{}) do
    entity.behaviors
  end

  @doc "Returns whether the passed 'name' can be used to refer to this entity"
  def is_called?(entity, name) do
    name == entity.id
  end
end
