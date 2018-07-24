defmodule Doro.World.WorldFile do
  @moduledoc """
  This module knows how to load doro world files.  It returns a map that can be passed to `Doro.GameState.set/1`.

  A world file is a JSON file like this:
  ```
  {
    "entities": [
      { <entity specification> }
    ],

    "sources": [
      "gist://da12988d0ac6b7eef0136e4fb7d74720",
      "https://www.example.com/zones/shire.json",
      "priv_file://default.json",
      "priv_file://prototypes.json"
    ]
  }
  ```
  The sources are loaded in order.  Entities with colliding ids in subsequent sources overwrite
  previous ones.

  The canonical prototypes should be the last ones loaded, so that the behavior for common entities
  like `_player` are consistent.

  Returns an array of entity "specifications"
  """

  require Logger

  def load_source("http://" <> _ = url), do: load_url(url)
  def load_source("https://" <> _ = url), do: load_url(url)

  def load_source("priv_file://" <> path = source_spec) do
    filepath = Path.join(:code.priv_dir(:doro), path)
    Logger.info("Loading entities from local file: #{filepath}")
    parse({source_spec, File.read!(filepath)})
  end

  def load_source("gist://" <> gist_id = source_spec) do
    Logger.info("Loading entities from gist: #{gist_id}")
    parse({source_spec, Doro.Utils.load_gist(gist_id)})
  end

  def load_debug(entities) do
    entities
    |> Enum.map(&Doro.World.Marshal.unmarshal_entity/1)
  end

  defp load_url(url) do
    Logger.info("Loading entities from url: #{url}")
    parse({url, Doro.Utils.load_url(url)})
  end

  defp parse({load_source, source}) do
    parsed = Poison.decode!(source, keys: :atoms)

    entities =
      Map.get(parsed, :entities, [])
      |> Enum.map(&Doro.World.Marshal.unmarshal_entity/1)
      |> Enum.map(&Map.put(&1, :src, load_source))

    imported = Map.get(parsed, :sources, []) |> load_sources()
    entities ++ imported
  end

  defp load_sources(sources) do
    sources
    |> Enum.map(&create_loader_task/1)
    |> Enum.map(&Task.await/1)
    |> Enum.concat()
  end

  defp create_loader_task(src) do
    Task.async(fn -> load_source(src) end)
  end
end
