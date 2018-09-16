import expect from "expect"
import {
  extractLocationsFromEntities,
  convertBehaviorsToArray,
  convertBehaviorsToHash
} from "./index"

describe("extractLocationsFromEntities", () => {
  let entities = [
    {
      props: {},
      name_tokens: ["sidewalk"],
      name: "sidewalk",
      id: "sidewalk",
      behaviors: [
        {
          type: "visible",
          own: true,
          description: "You are on a sidewalk."
        }
      ]
    },
    {
      id: "_private"
    },
    {
      props: {
        location: "bathroom"
      },
      name_tokens: ["machine", "sewing", "sewing machine"],
      name: "sewing machine",
      id: "juki",
      behaviors: [
        {
          type: "visible",
          description:
            "is a Juki DNU-1541, threaded with some #69 bonded nylon."
        }
      ]
    },
    {
      props: {
        location: "start"
      },
      name_tokens: ["open", "open window", "window"],
      name: "open window",
      id: "office-fire_escape-door",
      behaviors: [
        {
          type: "exit",
          own: true,
          destination_id: "fire_escape"
        },
        {
          type: "visible",
          own: true,
          description:
            "is a small fire escape that looks like a fire hazard itself."
        }
      ]
    }
  ]

  it("extracts locations from entities", () => {
    expect(extractLocationsFromEntities(entities)).toEqual(["sidewalk"])
  })
})

describe("convertBehaviorsToArray", () => {
  it("moves behavior from a hash to an array with hashes that include `type`", () => {
    const repacked = convertBehaviorsToArray({
      id: "the-thing",
      name: "the thing",
      behaviors: {
        visible: { description: "is the thing's description" },
        god: {}
      }
    })
    expect(repacked).toEqual({
      id: "the-thing",
      name: "the thing",
      behaviors: [
        { type: "visible", description: "is the thing's description" },
        { type: "god" }
      ]
    })
  })
  it("handles empty behaviors properly", () => {
    expect(convertBehaviorsToArray({})).toEqual({})
    expect(convertBehaviorsToArray({ behaviors: {} })).toEqual({
      behaviors: []
    })
  })
})

describe("convertBehaviorsToHash", () => {
  it("moves behavior from a hash to an array with hashes that include `type`", () => {
    const repacked = convertBehaviorsToHash({
      id: "the-thing",
      name: "the thing",
      behaviors: [
        { type: "visible", description: "is the thing's description" },
        { type: "god" }
      ]
    })
    expect(repacked).toEqual({
      id: "the-thing",
      name: "the thing",
      behaviors: {
        visible: { description: "is the thing's description" },
        god: {}
      }
    })
  })
  it("handles empty behaviors properly", () => {
    expect(convertBehaviorsToHash({})).toEqual({})
    expect(convertBehaviorsToHash({ behaviors: [] })).toEqual({
      behaviors: {}
    })
  })
})
