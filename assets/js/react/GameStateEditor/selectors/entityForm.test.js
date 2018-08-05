import expect from "expect"
import { convertBehaviorsToArray, convertBehaviorsToHash } from "./entityForm"

describe("entityForm selectors", () => {
  describe("convertBehaviorsToArray", () => {
    it("moves behavior from a hash to an array with hashes that include `type`", () => {
      const repacked = convertBehaviorsToArray({
        id: "the-thing",
        name: "the thing",
        behaviors: {
          visible: { description: "is the thing's description" },
          god: {},
        },
      })
      expect(repacked).toEqual({
        id: "the-thing",
        name: "the thing",
        behaviors: [
          { type: "visible", description: "is the thing's description" },
          { type: "god" },
        ],
      })
    })
    it("handles empty behaviors properly", () => {
      expect(convertBehaviorsToArray({})).toEqual({})
      expect(convertBehaviorsToArray({ behaviors: {} })).toEqual({
        behaviors: [],
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
          { type: "god" },
        ],
      })
      expect(repacked).toEqual({
        id: "the-thing",
        name: "the thing",
        behaviors: {
          visible: { description: "is the thing's description" },
          god: {},
        },
      })
    })
    it("handles empty behaviors properly", () => {
      expect(convertBehaviorsToHash({})).toEqual({})
      expect(convertBehaviorsToHash({ behaviors: [] })).toEqual({
        behaviors: {},
      })
    })
  })
})
