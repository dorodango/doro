defmodule MapHelpers do
  def atomize_keys(nil), do: %{}
  def atomize_keys(map), do: for({key, val} <- map, into: %{}, do: atomize(key, val))
  def atomize(key, val) when is_binary(key), do: {String.to_atom(key), val}
  def atomize(key, val), do: {key, val}
end
