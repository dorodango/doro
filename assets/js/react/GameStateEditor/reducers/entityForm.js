import { omit, mergeDeepRight } from "ramda"
import { camelizeKeys } from "humps"
import {
  FETCH_AVAILABLE_BEHAVIORS,
  FETCH_AVAILABLE_BEHAVIORS_SUCCESS,
  FETCH_AVAILABLE_BEHAVIORS_FAILURE,
  ADD_ENTITY,
  ADD_ENTITY_SUCCESS,
  ADD_ENTITY_FAILURE
} from "../actions/entityForm"
import {
  EDIT_ENTITY,
  CLOSE_EDIT_PANE
} from "../../actions/app"

import { convertBehaviorsToHash } from "../selectors"

export const defaultState = {
  availableBehaviors: [],
  entity: {}
}

export default function(state = defaultState, action) {
  const data = camelizeKeys(action.data)
  switch (action.type) {
    case CLOSE_EDIT_PANE:
      return mergeDeepRight(state, { entity: {} })

    case EDIT_ENTITY:
      if (data) {
        let entity = data.entity || data.body.data.entity;
        entity = omit(["src"], convertBehaviorsToHash(entity))
        return mergeDeepRight(state, { entity, editStarted: new Date() })
      }
      return state

    case ADD_ENTITY:
    case FETCH_AVAILABLE_BEHAVIORS:
      return mergeDeepRight(state, {
        loading: true
      })
    case ADD_ENTITY_SUCCESS:
      return mergeDeepRight(state, {
        entity: data.entity,
        loading: false,
      })
    case FETCH_AVAILABLE_BEHAVIORS_SUCCESS:
      return mergeDeepRight(state, {
        availableBehaviors: data.behaviors,
        behaviorShapes: data.behaviorShapes,
        loading: false,
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
