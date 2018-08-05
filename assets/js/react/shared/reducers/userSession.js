import { mergeDeepRight, mergeDeepWith, append } from "ramda"
import {
  SEND_HELLO,
  SEND_HELLO_SUCCESS,
  SEND_HELLO_FAILURE,
  SEND_COMMAND,
  SEND_COMMAND_SUCCESS,
  SEND_COMMAND_FAILURE,
} from "../actions/channel"

export const defaultState = {
  playerId: null,
  playerName: null,
  messages: [],
}

export default function(state = defaultState, action) {
  switch (action.type) {
    case SEND_HELLO_SUCCESS:
      if (state.playerId) {
        return state
      }
      return mergeDeepRight(state, {
        playerId: action.data.player_id,
        playerName: action.data.player_name,
      })
    case SEND_COMMAND_SUCCESS:
      const response = action.data.body
      switch (response.data.type) {
        case "edit":
        case "default":
        default:
          return mergeDeepWith(append, { messages: response.text }, state)
      }
    case SEND_COMMAND_FAILURE:
    case SEND_HELLO:
    case SEND_COMMAND:
    default:
      return state
  }
}
