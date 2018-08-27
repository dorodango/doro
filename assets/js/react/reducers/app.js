import { mergeDeepRight } from "ramda"
import { TOGGLE_EDIT_PANE } from "../actions/app"

export const defaultState = {
  showEditPane: false
}

export default function(state = defaultState, action) {
  switch (action.type) {
    case TOGGLE_EDIT_PANE:
      return mergeDeepRight(state, { showEditPane: !state.showEditPane })
    default:
      return state
  }
}
