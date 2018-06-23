defmodule Doro.Entity do
  alias Doro.Entity

  defstruct proto: nil,
            id: nil,
            behaviors: [],
            name: nil,
            name_tokens: nil,
            props: %{}

  def execute_behaviors(ctx) do
    Enum.reduce(ctx.object.behaviors, ctx, fn behavior, acc -> behavior.handle(acc) end)
  end

  @doc "Returns the first behavior that can handle this verb in this context"
  def first_responder(entity = %Entity{}, ctx = %Doro.Context{verb: verb}) do
    behaviors(entity)
    |> Enum.find(& &1.responds_to?(verb, %{ctx | object: entity}))
  end

  @doc "Returns all behaviors for this entity"
  def behaviors(nil), do: []

  def behaviors(entity = %Entity{}) do
    entity.behaviors ++ behaviors(entity.proto)
  end

  @doc "Returns a property for this entity, including looking up the prototype chain"
  def get_prop(nil, _), do: :error

  def get_prop(%Entity{proto: proto, props: props}, key) do
    Map.get(props, key, get_prop(proto, key))
  end

  @doc "Returns {<new value>, entity}"
  def set_prop(entity = %Entity{props: props}, key, value) do
    {value, %{entity | props: Map.put(props, key, value)}}
  end

  @doc """
  Returns whether the passed 'name' can be used to refer to this entity

    'red pen' -> <redpen>
    'red' -> <redpen>
    'pen' -> <redpen>, <bluepen>
  """
  def named?(entity, name) do
    entity.name_tokens
    |> MapSet.member?(String.downcase(name))
  end

  def name(entity) do
    entity.name || entity.id
  end

  def has_behavior?(entity, behavior) do
    Enum.member?(entity.behaviors, behavior)
  end

  def is_person?(entity) do
    entity
    |> has_behavior?(Doro.Behaviors.Player)
  end

  @behaviour Access

  @impl Access
  def fetch(entity, key) do
    case get_prop(entity, key) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  @impl Access
  def get(entity, key, default \\ nil) do
    case get_prop(entity, key) do
      :error -> default
      value -> value
    end
  end

  # This behavior is wrong I think
  @impl Access
  def pop(entity, key, default \\ nil) do
    {value, new_props} = Map.pop(entity, key, default)
    {value, %{entity | props: new_props}}
  end

  # This behavior is wrong I think
  @impl Access
  def get_and_update(entity, key, fun) do
    {value, new_props} = Map.get_and_update(entity.props, key, fun)
    {value, %{entity | props: new_props}}
  end
end
