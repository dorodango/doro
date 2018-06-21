defmodule Doro.ParserTest do
  use ExUnit.Case, async: true

  test "parse/2" do
    assert {"take", "plant"} = Doro.Parser.parse(" take  plant")
  end
end
