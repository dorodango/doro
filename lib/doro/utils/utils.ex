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
  def load_url(url, params \\ %{}) do
    url
    |> HTTPoison.get!([], params: params)
    |> Map.get(:body)
  end

  def munge_entity_file(priv_path) do
    Path.join(:code.priv_dir(:doro), priv_path)
    |> File.read!()
    |> Poison.decode!(keys: :atoms)
    |> Map.get(:entities)
    |> Enum.map(&munge/1)
    |> (&%{entities: &1}).()
    |> Poison.encode!(pretty: true)
    |> IO.write()
  end

  defp munge(data) do
    data
    |> fixup_exit()
  end

  defp fixup_exit(%{behaviors: behaviors, props: %{destination_id: destination_id}} = data) do
    behaviors = [
      %{type: "exit", destination_id: destination_id} | Enum.reject(behaviors, &(&1 == "exit"))
    ]

    %{data | behaviors: behaviors, props: Map.drop(data.props, [:destination_id])}
  end

  defp fixup_exit(data), do: data
end
