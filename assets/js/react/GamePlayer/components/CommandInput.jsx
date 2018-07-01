import React, { Component } from "react"
import PropTypes from "proptypes"

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
  }

  handleKeyPress = ev => {
    const cmd = this.input.current.value
    if (ev.key === "Enter" && cmd.length) {
      this.channel.push("cmd", {
        cmd: cmd,
      })
      this.input.current.value = ""
    }
  }

  render() {
    return (
      <div id="footer">
        <input
          id="input"
          onKeyPress={this.handleKeyPress}
          ref={this.input}
          placeholder="Enter a command"
          autoFocus={true}
        />
      </div>
    )
  }
}

export default CommandInput
