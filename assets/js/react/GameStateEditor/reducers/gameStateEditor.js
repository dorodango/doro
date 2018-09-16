import { mergeDeepRight } from "ramda"
import {
  FETCH_ENTITIES,
  FETCH_ENTITIES_SUCCESS,
  FETCH_ENTITIES_FAILURE,
} from "../actions/gameStateEditor"
import {
  EDIT_ENTITY
} from "../../actions/app"

import { extractLocationsFromEntities } from "../selectors"

export const defaultState = {
  entities: [],
  activeTab: null,
  loading: false
}

export default function(state = defaultState, action) {
  switch (action.type) {
  case EDIT_ENTITY:
      return mergeDeepRight(state, { activeTab: "Editor" });
    case FETCH_ENTITIES:
      return mergeDeepRight(state, {
        loading: true
      })
    case FETCH_ENTITIES_SUCCESS:
      // save entities and extract locations and destinations
      return mergeDeepRight(state, {
        entities: action.data.entities,
        locations: extractLocationsFromEntities(action.data.entities),
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
