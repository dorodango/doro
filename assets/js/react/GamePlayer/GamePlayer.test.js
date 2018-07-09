import React from "react"
import ReactDOM from "react-dom"

import GamePlayer from "./GamePlayer"

describe("GamePlayer", () => {
  it("renders without crashing", () => {
    const div = document.createElement("div")
    ReactDOM.render(<GamePlayer />, div)
  })
})
