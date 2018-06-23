defmodule Doro.EntityTest do
  use ExUnit.Case, async: true

  alias Doro.Entity

  setup do
    entity =
      """
      {
        "id": "plant",
        "name": "Fiddleleaf Fig",
        "behaviors": ["visible", "portable", "vascular_plant"],
        "props": {
          "location": "office",
          "description": "is herbaceous, glabrous, and four-pinnate."
        }
      }
      """
      |> Poison.decode!(keys: :atoms)
      |> Doro.World.Marshal.unmarshal_entity()

    [entity: entity]
  end

  test "named?/2", %{entity: entity} do
    assert Entity.named?(entity, "fig")
    assert Entity.named?(entity, "Fig")
    assert Entity.named?(entity, "fiddleleaf")
    assert Entity.named?(entity, "Fiddleleaf fig")
  end
end
