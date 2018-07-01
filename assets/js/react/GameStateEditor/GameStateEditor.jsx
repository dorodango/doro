import React, { Component } from "react"
import EntityForms from "./components/EntityForms/EntityForms"

class GameStateEditor extends Component {
  render() {
    return (
      <div className="GameStateEditor">
        <header className="GameStateEditor-header">
          <h1 className="GameStateEditor-title">
            Generate your Doro Game State Here!
          </h1>
        </header>
        <main className="GameStateEditor-intro">
          <EntityForms />
        </main>
      </div>
    )
  }
}

export default GameStateEditor
