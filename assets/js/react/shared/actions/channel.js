export const SEND_COMMAND = "channel/SEND_COMMAND"
export const SEND_COMMAND_SUCCESS = "channel/SEND_COMMAND_SUCCESS"
//export const SEND_COMMAND_FAILURE = "channel/SEND_COMMAND_FAILURE"
export const SEND_HELLO = "channel/SEND_HELLO"
export const SEND_HELLO_SUCCESS = "channel/SEND_HELLO_SUCCESS"
//export const SEND_HELLO_FAILURE = "channel/SEND_HELLO_FAILURE"

export const sendCommand = data => ({ type: SEND_COMMAND, data })
export const sendCommandSuccess = data => ({ type: SEND_COMMAND_SUCCESS, data })
//export const sendCommandFailure = data => ({ type: SEND_COMMAND_FAILURE, data })

export const sendHello = data => ({ type: SEND_HELLO, data })
export const sendHelloSuccess = data => ({ type: SEND_HELLO_SUCCESS, data })
//export const sendHelloFailure = data => ({ type: SEND_HELLO_FAILURE, data })
