import React, { Component } from "react"
import { Socket as PhoenixSocket } from "phoenix"

import JoinForm from "./components/JoinForm"
import CommandInput from "./components/CommandInput"
import DoroConsole from "./components/DoroConsole"

const socket = new PhoenixSocket("/socket")
socket.connect()

class GamePlayer extends Component {
  constructor(props) {
    super(props)
    this.state = {
      player: null,
    }
    this.socket = socket
  }

  join = playerName => {
    const currentState = this.state
    const cb = playerId => {
      const newState = { player: { playerName, playerId } }
      this.setState({ ...currentState, ...newState })
    }
    const ch = this.socket.channel(`hello:${playerName}`)
    ch.on("player_info", payload => cb(payload.player_id))
    ch.join()
  }

  onLogin = playerName => {
    this.join(playerName)
  }

  loggedIn = () => {
    return this.state.player && this.state.player.playerId.length > 0
  }

  render() {
    return (
      <div className="GamePlayer">
        {!this.loggedIn() && <JoinForm onLogin={this.onLogin} />}
        {this.loggedIn() && (
          <DoroConsole socket={this.socket} player={this.state.player} />
        )}
        {this.loggedIn() && (
          <CommandInput socket={this.socket} player={this.state.player} />
        )}
      </div>
    )
  }
}

export default GamePlayer
