import React from "react"
import ReactDOM from "react-dom"
import moxios from "moxios"

import GameStateEditor from "./GameStateEditor"

describe("GameStateEditor", () => {
  beforeEach(function() {
    moxios.install()
  })

  afterEach(function() {
    moxios.uninstall()
  })

  it("renders without crashing", () => {
    const div = document.createElement("div")
    ReactDOM.render(<GameStateEditor />, div)
    ReactDOM.unmountComponentAtNode(div)
  })
})
