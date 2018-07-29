import React, { Component } from "react"
import PropTypes from "proptypes"
import { isEmpty } from "ramda"

class CommandInput extends Component {
  static propTypes = {
    player: PropTypes.object.isRequired,
    socket: PropTypes.object.isRequired,
  }

  constructor(props) {
    super(props)
    this.input = React.createRef()

    const { player, socket } = this.props
    const channel = socket.channel(`player:${player.playerId}`)
    channel.join()
    this.channel = channel

    this.history = []
    this.historyIndex = -1
  }

  handleKeyDown = ev => {
    let cmd
    switch (ev.key) {
      case "Enter":
        cmd = this.input.current.value
        if (!isEmpty(cmd)) {
          this.channel.push("cmd", { cmd: cmd })
          this.history.unshift(cmd)
          this.input.current.value = ""
        }
        break
      case "ArrowUp":
        this.restoreHistory(1)
        ev.preventDefault()
        break
      case "ArrowDown":
        this.restoreHistory(-1)
        ev.preventDefault()
        break
      default:
        this.historyIndex = -1
    }
  }

  restoreHistory = offset => {
    let idx = this.historyIndex + offset
    idx = Math.max(0, Math.min(idx, this.history.length - 1))
    this.input.current.value = this.history[idx]
    this.historyIndex = idx
  }

  render() {
    return (
      <div id="footer">
        <input
          id="input"
          onKeyDown={this.handleKeyDown}
          ref={this.input}
          placeholder="Enter a command"
          autoFocus={true}
        />
      </div>
    )
  }
}

export default CommandInput
