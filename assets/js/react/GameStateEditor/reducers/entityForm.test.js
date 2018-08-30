import expect, { objectContaining } from "expect"
import reducer, { defaultState } from "./entityForm"
import {
  addEntity,
  fetchAvailableBehaviors,
  addEntitySuccess,
  fetchAvailableBehaviorsSuccess,
  addEntityFailure,
  fetchAvailableBehaviorsFailure,
} from "../actions/entityForm"

describe("entityForm.reducer", () => {
  it("has a default state", () => {
    const state = reducer(undefined, {})
    expect(state).toEqual(defaultState)
  })

  describe("ADD_ENTITY", () => {
    it("sets loading true", () => {
      const state = reducer({}, addEntity({}))
      expect(state).toEqual(objectContaining({ loading: true }))
    })
  })
  describe("ADD_ENTITY_SUCCESS", () => {
    it("sets loading false", () => {
      const state = reducer({}, addEntitySuccess({}))
      expect(state).toEqual(objectContaining({ loading: false }))
    })
    it("adds the entity data", () => {
      const entity = { here: "it is" }
      const state = reducer({}, addEntitySuccess({ entity }))
      expect(state).toEqual(objectContaining({ entity }))
    })
  })
  describe("ADD_ENTITY_FAILURE", () => {
    it("sets loading false", () => {
      const state = reducer({}, addEntityFailure({}))
      expect(state).toEqual(objectContaining({ loading: false }))
    })
  })
  describe("FETCH_AVAILABLE_BEHAVIORS", () => {
    it("sets loading true", () => {
      const state = reducer({}, fetchAvailableBehaviors({}))
      expect(state).toEqual(objectContaining({ loading: true }))
    })
  })
  describe("FETCH_AVAILABLE_BEHAVIORS_SUCCESS", () => {
    it("sets loading false", () => {
      const state = reducer({}, fetchAvailableBehaviorsSuccess({}))
      expect(state).toEqual(objectContaining({ loading: false }))
    })
    it("sets the state to include the behaviors", () => {
      const behaviors = ["whatever", "data", "comes", "back"]
      const state = reducer({}, fetchAvailableBehaviorsSuccess({ behaviors }))
      expect(state).toEqual(objectContaining({ availableBehaviors: behaviors }))
    })
  })
  describe("FETCH_AVAILABLE_BEHAVIORS_FAILURE", () => {
    it("sets loading false", () => {
      const state = reducer({}, fetchAvailableBehaviorsFailure({}))
      expect(state).toEqual(objectContaining({ loading: false }))
    })
  })
})
