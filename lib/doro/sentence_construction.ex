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

  @physical_adjectives ~w(
    boiling
    broken
    bumpy
    burning
    chilly
    clammy
    coarse
    cold
    cool
    creepy
    crisp
    crooked
    cuddly
    curly
    damp
    dirty
    downy
    dry
    dusty
    feathery
    filthy
    fine
    firm
    fishy
    flaky
    fleshy
    fluffy
    freezing
    frosty
    furry
    fuzzy
    grainy
    granular
    greasy
    grimy
    gritty
    hairy
    half
    hard
    hot
    humid
    icy
    leathery
    loose
    lukewarm
    lumpy
    moist
    mucky
    muddy
    muggy
    mushy
    oily
    pebbly
    pointed
    prickly
    rigid
    rough
    rubbery
    sandy
    scorching
    sensitive
    sharp
    silky
    slick
    slimy
    slippery
    smooth
    sodden
    soft
    soggy
    solid
    spiky
    spongy
    steamy
    sticky
    stiff
    tacky
    tender
    tepid
    thick
    thin
    tough
    uneven
    velvety
    warm
    watery
    wavy
    waxy
    wet
    wobbly
    wooly
  )
  def physical_adjective do
    Enum.random(@physical_adjectives)
  end

  defp indefinite_article(s) do
    if Regex.match?(~r/^[aeiou]/i, s), do: "an", else: "a"
  end
end
