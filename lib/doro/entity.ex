defmodule Doro.Entity do
  alias Doro.Entity

  defstruct id: nil,
            behaviors: [],
            props: %{}

  def execute_behaviors(ctx) do
    Enum.reduce(ctx.object.behaviors, ctx, fn behavior, acc -> behavior.handle(acc) end)
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

  @doc """
  Returns whether the passed 'name' can be used to refer to this entity

    'red pen' -> <redpen>
    'red' -> <redpen>
    'pen' -> <redpen>, <bluepen>
  """
  def named?(entity, name) do
    name == entity.id
  end

  def name(entity) do
    "[#{entity.id}]"
  end

  @behaviour Access

  @impl Access
  def fetch(entity, key) do
    Map.fetch(entity.props, key)
  end

  @impl Access
  def get(entity, key, default \\ nil) do
    Map.get(entity.props, key, default)
  end

  @impl Access
  def pop(entity, key, default \\ nil) do
    {value, new_props} = Map.pop(entity, key, default)
    {value, %{entity | props: new_props}}
  end

  @impl Access
  def get_and_update(entity, key, fun) do
    {value, new_props} = Map.get_and_update(entity.props, key, fun)
    {value, %{entity | props: new_props}}
  end
end
