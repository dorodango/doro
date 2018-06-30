defmodule Doro.Utils do
  @moduledoc """
  The usual dumping ground
  """

  @doc "Returns the contents of the first file of the latest revision of a gist"
  def load_gist(gist_id) do
    "https://api.github.com/gists/#{gist_id}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Poison.decode!(keys: :atoms)
    |> Map.get(:files)
    |> Map.values()
    |> List.first()
    |> Map.get(:raw_url)
    |> HTTPoison.get!()
    |> Map.get(:body)
  end

  @doc "Returns the contents at a URL"
  def load_url(url) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
  end
end
