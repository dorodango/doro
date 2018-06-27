defmodule Doro.ParserTest do
  use ExUnit.Case, async: true

  test "parse/1" do
    assert {"take", "plant"} = Doro.Parser.parse(" take  plant")
    assert {"take", "fiddleleaf fig"} = Doro.Parser.parse(" take  fiddleleaf fig    ")
    assert {"/command", nil} = Doro.Parser.parse("/command   ")
    assert {"/command", nil} = Doro.Parser.parse("   /command")
    assert {"/command", nil} = Doro.Parser.parse("/command")
  end
end
