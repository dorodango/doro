import { mergeDeepRight } from "ramda"
import {
  FETCH_ENTITIES,
  FETCH_ENTITIES_SUCCESS,
  FETCH_ENTITIES_FAILURE
} from "../actions/gameStateEditor"

export const defaultState = {
  entities: []
}

export default function(state = defaultState, action) {
  switch (action.type) {
    case FETCH_ENTITIES:
      return mergeDeepRight(state, {
        loading: true
      })
    case FETCH_ENTITIES_SUCCESS:
      // save entities and extract locations and destinations
      return mergeDeepRight(state, {
        entities: action.data.entities,
        loading: false
      })
    case FETCH_ENTITIES_FAILURE:
      return mergeDeepRight(state, {
        loading: false
      })
    default:
      return state
  }
}
