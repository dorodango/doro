defmodule Doro.TestFixtures do
  def read_fixture(filename) do
    "fixtures/#{filename}"
    |> Path.expand(Application.app_dir(:doro, "priv"))
    |> File.read!()
  end
end
