import expect, { objectContaining } from "expect"
import reducer, { defaultState } from "./gameStateEditor"
import {
  fetchEntities,
  fetchEntitiesSuccess,
  fetchEntitiesFailure,
} from "../actions/gameStateEditor"

describe("gameStateEditor.reducer", () => {
  const entities = [
    { id: "a-location", name: "a location" },
    { id: "not-a-location", props: { location: "a-location" }}
  ]

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
      expect(reducer({}, fetchEntitiesSuccess({ entities }))).toEqual(
        objectContaining({ entities })
      )
    })
    it("sets the state to include the locations as extracted from the entities", () => {
      expect(reducer({}, fetchEntitiesSuccess({ entities }))).toEqual(
        objectContaining({ locations: ["a-location"] })
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
