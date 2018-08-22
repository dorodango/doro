import reducer, { defaultState } from "./app"
import { toggleEditPane } from "../actions/app"

describe("app.reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("TOGGLE_EDIT_PANE", () => {
    it("toggles the showEditPane on", function() {
      const state = reducer(
        { the: "app state" },
        toggleEditPane({ data: "data" })
      )
      expect(state).toEqual({ the: "app state", showEditPane: true })
    })
    it("toggles the showEditPane off it it's on", function() {
      const state = reducer(
        { the: "app state", showEditPane: true },
        toggleEditPane({ data: "data" })
      )
      expect(state).toEqual({ the: "app state", showEditPane: false })
    })
  })
})
