import reducer, { defaultState } from "./tabs"
import { activateTab } from "../actions/tabs"
import { editEntity } from "../../actions/app"

describe("tabs reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("EDIT_ENTITY", () => {
    it("adds the message to the store", () => {
      const state = reducer({}, editEntity({}))
      expect(state).toEqual({ activeTab: "Editor" })
    })
  })

  describe("ACTIVATE_TAB", () => {
    it("removes the flash message from the store", () => {
      const state = reducer({ activeTab: "Whatever" }, activateTab("newTab"))
      expect(state).toEqual({ activeTab: "newTab" })
    })
  })
})
