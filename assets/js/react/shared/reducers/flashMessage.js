import { mergeDeepRight } from "ramda"
import {
  ADD_FLASH_MESSAGE,
  REMOVE_FLASH_MESSAGE
} from "../actions/flashMessage"

export const defaultState = {}

export default function(state = defaultState, action) {
  switch (action.type) {
    case ADD_FLASH_MESSAGE:
      return mergeDeepRight(state, action.data)
    case REMOVE_FLASH_MESSAGE:
      return mergeDeepRight(state, { text: null, type: null })
    default:
      return state
  }
}
