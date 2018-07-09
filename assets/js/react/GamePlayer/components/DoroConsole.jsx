import React, { Component } from "react"
import PropTypes from "proptypes"

import DoroOutput from "./DoroOutput"

class DoroConsole extends Component {
  static propTypes = {
    player: PropTypes.object.isRequired,
    socket: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)

    const { player, socket } = props
    const channel = socket.channel(`player:${player.playerId}`)
    this.channel = channel
  }

  render() {
    const { player } = this.props
    return (
      <div className="DoroConsole">
        <div className="DoroConsole__player">{player.playerName}</div>
        <DoroOutput player={this.props.player} channel={this.channel} />
      </div>
    )
  }
}

export default DoroConsole
