import { takeLatest, take, put, call, select, all } from "redux-saga/effects"
import { eventChannel } from "redux-saga"
import { Socket } from "phoenix"

import {
  SEND_HELLO,
  SEND_COMMAND,
  sendCommandSuccess,
  sendCommandFailure,
  sendHelloSuccess,
  sendHelloFailure
} from "../actions/channel"

/* for a selector? */
const getUserSession = state => state.userSession

export function* configureChannel(url) {
  let socket = new Socket(url, {
    logger: (kind, msg, data) => {
      console.log(`${kind}: ${msg}`, data)
    }
  })
  socket.connect()
  return socket
}

function createPlayerInfoChannel(channel) {
  return eventChannel(emit => {
    const handleHelloResponse = ev => {
      emit(sendHelloSuccess(ev))
    }

    channel.on("player_info", handleHelloResponse)
    const unsubscribe = () => {
      channel.off("player_info", handleHelloResponse)
    }
    return unsubscribe
  })
}

function createCommandChannel(channel) {
  return eventChannel(emit => {
    const handleCommandResponse = ev => {
      emit(sendCommandSuccess(ev))
    }
    channel.on("output", handleCommandResponse)
    const unsubscribe = () => {
      channel.off("output", handleCommandResponse)
    }
    return unsubscribe
  })
}

function* joinChannel(socket, channelName) {
  const channel = socket.channel(channelName, {})
  channel.join()
  return channel
}

function* sendHello(action) {
  const playerName = action.data
  const socket = yield call(configureChannel, "/socket")
  const channel = yield call(joinChannel, socket, `hello:${playerName}`)
  const socketChannel = yield call(createPlayerInfoChannel, channel)

  while (true) {
    const action = yield take(socketChannel)
    yield put(action)
  }
}

function* sendCommand(action) {
  const userSession = yield select(getUserSession)
  const { playerName, playerId } = userSession
  const socket = yield call(configureChannel, "/socket")
  const channel = yield call(joinChannel, socket, `player:${playerId}`)
  const socketChannel = yield call(createCommandChannel, channel)
  channel.push("cmd", action.data)
  while (true) {
    const action = yield take(socketChannel)
    yield put(action)
  }
}

export default function* joinSaga() {
  yield all([
    takeLatest(SEND_HELLO, sendHello),
    takeLatest(SEND_COMMAND, sendCommand)
  ])
}
