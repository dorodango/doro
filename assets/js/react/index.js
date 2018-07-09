import React from "react"
import ReactDOM from "react-dom"
import GameStateEditor from "./GameStateEditor/GameStateEditor"
import GamePlayer from "./GamePlayer/GamePlayer"

const editorRoot = document.getElementById("GameStateEditor")
if (editorRoot) {
  ReactDOM.render(<GameStateEditor />, editorRoot)
}

const gamePlayRoot = document.getElementById("GamePlayer")
if (gamePlayRoot) {
  ReactDOM.render(<GamePlayer />, gamePlayRoot)
}
