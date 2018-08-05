import reducer, { defaultState } from "./flashMessage"
import { addFlashMessage, removeFlashMessage } from "../actions/flashMessage"

describe("Flash Message reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("ADD_FLASH_MESSAGE", () => {
    it("adds the message to the store", () => {
      const state = reducer(
        {},
        addFlashMessage({ type: "info", text: "flash it" })
      )
      expect(state).toEqual({
        text: "flash it",
        type: "info",
      })
    })
  })

  describe("REMOVE_FLASH_MESSAGE", () => {
    it("removes the flash message from the store", () => {
      const state = reducer(
        { type: "info", text: "flash it" },
        removeFlashMessage()
      )
      expect(state).toEqual({ type: null, text: null })
    })
  })
})
