import { mergeDeepRight } from "ramda"
import {
  FETCH_AVAILABLE_BEHAVIORS,
  FETCH_AVAILABLE_BEHAVIORS_SUCCESS,
  FETCH_AVAILABLE_BEHAVIORS_FAILURE,
  ADD_ENTITY,
  ADD_ENTITY_SUCCESS,
  ADD_ENTITY_FAILURE
} from "../actions/entityForm"

export const defaultState = {
  availableBehaviors: [],
  entity: {}
}

export default function(state = defaultState, action) {
  switch (action.type) {
    case ADD_ENTITY:
    case FETCH_AVAILABLE_BEHAVIORS:
      return mergeDeepRight(state, {
        loading: true
      })
    case ADD_ENTITY_SUCCESS:
      return mergeDeepRight(state, {
        entity: action.data.entity,
        loading: false
      })
    case FETCH_AVAILABLE_BEHAVIORS_SUCCESS:
      return mergeDeepRight(state, {
        availableBehaviors: action.data.behaviors,
        loading: false
      })
    case ADD_ENTITY_FAILURE:
    case FETCH_AVAILABLE_BEHAVIORS_FAILURE:
      return mergeDeepRight(state, {
        loading: false
      })
    default:
      return state
  }
}
