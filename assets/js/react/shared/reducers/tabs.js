import { mergeDeepRight } from "ramda"
import {
  ACTIVATE_TAB
} from "../actions/tabs"
import {
  EDIT_ENTITY
} from "../../actions/app"

export const defaultState = {
}

export default function(state = defaultState, action) {
  switch (action.type) {
    case EDIT_ENTITY:
    return mergeDeepRight(state, { activeTab: "Editor" })
    case ACTIVATE_TAB:
    return mergeDeepRight(state, { activeTab: action.data })
    default:
      return state
  }
}
