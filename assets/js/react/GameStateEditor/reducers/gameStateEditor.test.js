import expect, { objectContaining } from "expect"
import reducer, { defaultState } from "./gameStateEditor"
import {
  fetchEntities,
  fetchEntitiesSuccess,
  fetchEntitiesFailure,
} from "../actions/gameStateEditor"

describe("gameStateEditor.reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("FETCH_ENTITIES", () => {
    it("sets the state loading : true", () => {
      expect(reducer({}, fetchEntities({}))).toEqual(
        objectContaining({ loading: true })
      )
    })
  })
  describe("FETCH_ENTITIES_SUCCESS", () => {
    it("sets the state loading : false", () => {
      expect(reducer({}, fetchEntitiesSuccess({}))).toEqual(
        objectContaining({ loading: false })
      )
    })
    it("sets the state to include the found entities", () => {
      const entities = [{ name: "the name" }]
      expect(reducer({}, fetchEntitiesSuccess({ entities }))).toEqual(
        objectContaining({ entities })
      )
    })
  })
  describe("FETCH_ENTITIES_FAILURE", () => {
    it("sets the state loading : false", () => {
      expect(reducer({}, fetchEntitiesFailure({}))).toEqual(
        objectContaining({ loading: false })
      )
    })
  })
})
