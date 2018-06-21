defmodule Doro.GameState.Gist do
  require Logger
  alias Doro.GameState.Marshal

  def load_gist(gist_id) do
    Logger.info("Fetching gist: https://api.github.com/gists/#{gist_id}")

    "https://api.github.com/gists/#{gist_id}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Poison.decode!(keys: :atoms)
    |> Map.get(:files)
    |> Map.values()
    |> List.first()
    |> read_gist_body()
    |> Marshal.unmarshal()
  end

  defp read_gist_body(%{truncated: false, content: content}) do
    IO.write(content)
    content
  end

  defp read_gist_body(%{truncated: true, raw_url: url}) do
    url
    |> HTTPoison.get!()
    |> Map.get(:body)
  end
end
