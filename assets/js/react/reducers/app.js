import { mergeDeepRight } from "ramda"
import { CLOSE_EDIT_PANE, EDIT_ENTITY } from "../actions/app"

export const defaultState = {
  showEditPane: false
}

export default function(state = defaultState, action) {
  switch (action.type) {
    case EDIT_ENTITY:
      return mergeDeepRight(state, { showEditPane: true })
    case CLOSE_EDIT_PANE:
      return mergeDeepRight(state, { showEditPane: false })
    default:
      return state
  }
}
