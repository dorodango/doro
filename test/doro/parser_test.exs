defmodule Doro.ParserTest do
  use ExUnit.Case, async: true

  test "parse/2" do
    assert {:ok, %{object: "plant", subject: "userid", verb: "take"}} =
             Doro.Parser.parse(" take  plant", "userid")
  end
end
