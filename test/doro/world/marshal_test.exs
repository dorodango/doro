defmodule Doro.World.MarshalTest do
  use ExUnit.Case, async: true

  alias Doro.World.Marshal

  describe "unmarshal/1" do
    setup do
      %{game_state: Marshal.unmarshal(read_fixture("world.json"))}
    end

    test "transforms JSON into a usable game state", %{game_state: %{entities: entity_map}} do
      assert 5 = Map.size(entity_map)

      %{
        "_player" => player_proto,
        "_god" => god_proto,
        "ice" => iceman
      } = entity_map

      assert [Doro.Behaviors.Visible, Doro.Behaviors.Player] = Doro.Entity.behaviors(player_proto)
      assert iceman.proto == god_proto
      assert god_proto.proto == player_proto
    end
  end

  defp read_fixture(filename) do
    "fixtures/#{filename}"
    |> Path.expand(Application.app_dir(:doro, "priv"))
    |> File.read!()
  end
end
