defmodule Doro.Behaviors.Turntable do
  use Doro.Behavior
  import Doro.Comms
  import Doro.SentenceConstruction

  import Inspector
  def responds_to?(verb,_) do
    ["stop","play","use"] 
    |> Enum.find(fn(r) -> r == verb end)
  end

  def handle(ctx = %{verb: "play"}), do: handle( %{ctx | verb: "use"})
  def handle(%{verb: "use", object: object, player: player}) do
    if (object.props[:playing]) do
       player |> send_to_player("It's already playing.")
    else
      Doro.World.set_prop(object, :playing, true)
      send_to_player(player, "You hear some funky music.")
      send_to_others(player, "The room fills with funky music.")
    end
  end

  def handle(%{verb: "stop", object: object, player: player}) do
    if (!object.props[:playing]) do
      player |> send_to_player("It's already not playing.")
    else
      Doro.World.set_prop(object, :playing, false)
      send_to_player(player, "The room goes silent")
      send_to_others(player, "The room goes silent")
    end
  end

end
