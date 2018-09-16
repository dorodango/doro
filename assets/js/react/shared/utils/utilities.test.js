import { isEmpty, isBlank } from "./utilities"

describe("utilities", () => {
  describe("isEmpty", () => {
    it("returns false for an object with elements", () => {
      expect(isEmpty({ a: 1 })).toBe(false)
    })

    it("returns true for an empty object", () => {
      expect(isEmpty({})).toBe(true)
    })

    it("returns true for null", () => {
      expect(isEmpty(null)).toBe(true)
    })

    it("returns true for undefined", () => {
      expect(isEmpty(undefined)).toBe(true)
    })

    it("returns true for empty string", () => {
      expect(isEmpty("")).toBe(true)
    })

    it("returns false for string of whitespace", () => {
      expect(isEmpty("  ")).toBe(false)
    })
  })

  describe("isBlank", () => {
    it("returns false for an object with elements", () => {
      expect(isBlank({ a: 1 })).toBe(false)
    })

    it("returns true for an empty object", () => {
      expect(isBlank({})).toBe(true)
    })

    it("returns true for null", () => {
      expect(isBlank(null)).toBe(true)
    })

    it("returns true for undefined", () => {
      expect(isBlank(undefined)).toBe(true)
    })

    it("returns true for empty string", () => {
      expect(isBlank("")).toBe(true)
    })

    it("returns true for string of whitespace", () => {
      expect(isBlank("  ")).toBe(true)
    })
  })
})
