import expect, { objectContaining } from "expect"
import reducer, { defaultState } from "./app"
import { closeEditPane, editEntity } from "../actions/app"

describe("app.reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("CLOSE_EDIT_PANE", () => {
    it("closes the edit pane if there is no info", function() {
      const state = reducer(
        { the: "app state" },
        closeEditPane({ data: "data" })
      )
      expect(state).toEqual({ the: "app state", showEditPane: false })
    })
    it("closes the edit pane it it's on", function() {
      const state = reducer(
        { the: "app state", showEditPane: true },
        closeEditPane({ data: "data" })
      )
      expect(state).toEqual({ the: "app state", showEditPane: false })
    })
  })
  describe("EDIT_ENTITY", () => {
    it("opens the edit pane", () => {
      const state = reducer(
        { the: "app state", showEditPane: false },
        editEntity({ data: { type: "open_entity_editor" } })
      )
      expect(state).toEqual(objectContaining({ showEditPane: true }))
    })
    it("does nothing the pane if action data type is not open_entity_editor", () => {
      let state = reducer(
        { the: "app state", showEditPane: true },
        editEntity({ data: { type: "open_entity_editor" } })
      )
      expect(state).toEqual(objectContaining({ showEditPane: true }))
      state = reducer(
        { the: "app state", showEditPane: false },
        editEntity({ data: { type: "open_entity_editor" } })
      )
      expect(state).toEqual(objectContaining({ showEditPane: true }))
    })
  })
})
