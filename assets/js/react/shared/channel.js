import { Socket } from "phoenix"

export function* configureChannel() {
  let socket = new Socket("/socket", {
    logger: (kind, msg, data) => {
      console.log(`${kind}: ${msg}`, data)
    }
  })

  socket.connect()

  return socket
}
