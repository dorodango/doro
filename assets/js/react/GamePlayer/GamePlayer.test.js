import React from "react"
import ReactDOM from "react-dom"

import { GamePlayer } from "./GamePlayer"

describe("GamePlayer", () => {
  const sendHelloSpy = jest.fn()

  it("renders without crashing", () => {
    const div = document.createElement("div")
    ReactDOM.render(<GamePlayer sendHello={sendHelloSpy} />, div)
  })
})
