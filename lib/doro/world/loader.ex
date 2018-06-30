defmodule Doro.World.Loader do
  @moduledoc """
  This module knows how to load doro world files.  It returns a map that can be passed to `Doro.GameState.set/1`.

  A world file is a JSON file like this:
  ```
  {
    "sources": [
      "gist://da12988d0ac6b7eef0136e4fb7d74720",
      "https://www.example.com/zones/shire.json",
      "priv_file://default.json",
      "priv_file://prototypes.json"
    ]
  }
  ```

  The sources are loaded in order.  Entities with colliding ids in subsequent sources overwrite
  previous ones.  If no errors occur, the running game state is replaced.

  The canonical prototypes should be the last in the list, so that the behavior for common entities
  like `_player` are consistent.
  """

  require Logger

  @doc "This takes a JSON string representing a world file, and loads it into the game state"
  def load(s) do
    s
    |> Poison.decode!(keys: :atoms)
    |> Map.get(:sources)
    |> Enum.map(&load_source(Regex.run(~r/(\w+):\/\/(.*$)/, &1)))
    |> aggregate_sources()
  end

  defp load_source([url, "http", _]), do: load_url(url)
  defp load_source([url, "https", _]), do: load_url(url)

  defp load_source([load_source, "priv_file", path]) do
    filepath = Path.join(:code.priv_dir(:doro), path)
    Logger.info("Loading entities from local file: #{filepath}")

    Task.async(fn ->
      {load_source, File.read!(filepath)}
    end)
  end

  defp load_source([load_source, "gist", gist_id]) do
    Logger.info("Loading entities from gist: #{gist_id}")

    Task.async(fn ->
      {load_source, Doro.Utils.load_gist(gist_id)}
    end)
  end

  defp load_url(url) do
    Logger.info("Loading entities from url: #{url}")

    Task.async(fn ->
      {url, Doro.Utils.load_url(url)}
    end)
  end

  defp aggregate_sources(load_tasks) do
    load_tasks
    |> Enum.map(&Task.await/1)
    |> Enum.map(&parse_entity_file/1)
    |> Enum.reduce([], fn %{entities: entities}, acc ->
      acc ++ entities
    end)
    |> (&%{entities: &1}).()
    |> Doro.World.Marshal.unmarshal()
  end

  defp parse_entity_file({load_source, source}) do
    # augment props with the load source
    data = Poison.decode!(source, keys: :atoms)
    %{data | entities: data.entities |> Enum.map(&Map.put(&1, :src, load_source))}
  end
end
