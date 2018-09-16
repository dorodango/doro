defmodule Doro.World.GameState do
  use GenServer

  alias Doro.Entity

  @table_name :entities

  def set(new_state) do
    GenServer.call(__MODULE__, {:set_entities, new_state.entities})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def clear do
    GenServer.call(__MODULE__, :clear)
  end

  def get, do: all_entities()

  def get_entity(nil), do: nil

  def get_entity(id) do
    case :ets.lookup(@table_name, id) do
      [{_, entity}] -> entity
      _ -> nil
    end
  end

  def get_entities(filter \\ & &1) do
    all_entities()
    |> Enum.filter(filter)
  end

  def set_prop(entity_id, key, value) when is_atom(key) do
    GenServer.call(__MODULE__, {:set_entity_prop, entity_id, key, value})
  end

  def add_entity(entity = %Entity{}) do
    add_entities([entity])
    entity
  end

  def add_entities(entities) do
    GenServer.call(__MODULE__, {:insert_entities, entities})
  end

  def remove_entity(entity = %Entity{}), do: remove_entity(entity.id)

  def remove_entity(entity_id) do
    set(%{entities: get_entities(fn e -> e.id != entity_id end)})
  end

  defp all_entities do
    :ets.match(@table_name, {:_, :"$1"}) |> List.flatten()
  end

  @impl true
  def init(default_entities) do
    entities_table = :ets.new(@table_name, [:named_table, read_concurrency: true])
    do_insert_entities(entities_table, default_entities)
    {:ok, {entities_table}}
  end

  @impl true
  def handle_call({:set_entity_prop, entity_id, key, value}, _from, {entities_table}) do
    entity = get_entity(entity_id) |> put_in([key], value)
    do_insert_entities(entities_table, [entity])
    {:reply, entity, {entities_table}}
  end

  @impl true
  def handle_call({:insert_entities, entities}, _from, {entities_table}) do
    do_insert_entities(entities_table, entities)
    {:reply, :ok, {entities_table}}
  end

  @impl true
  def handle_call({:set_entities, entities}, _from, {entities_table}) do
    :ets.delete_all_objects(entities_table)
    do_insert_entities(entities_table, entities)
    {:reply, :ok, {entities_table}}
  end

  @impl true
  def handle_call(:clear, _from, {entities_table}) do
    :ets.delete_all_objects(entities_table)
    {:reply, :ok, {entities_table}}
  end

  def do_insert_entities(entities_table, entities) do
    entities
    |> Enum.map(&{&1.id, &1})
    |> (&:ets.insert(entities_table, &1)).()
  end
end
