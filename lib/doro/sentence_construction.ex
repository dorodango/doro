defmodule Doro.SentenceConstruction do
  def indefinite(entity = %Doro.Entity{name: name}) do
    case Doro.Entity.is_person?(entity) do
      true -> name
      _ -> "#{indefinite_article(name)} #{name}"
    end
  end

  def definite(entity = %Doro.Entity{name: name}) do
    case Doro.Entity.is_person?(entity) do
      true -> name
      _ -> "the #{name}"
    end
  end

  defp indefinite_article(s) do
    if Regex.match?(~r/^[aeiou]/i, s), do: "an", else: "a"
  end
end
