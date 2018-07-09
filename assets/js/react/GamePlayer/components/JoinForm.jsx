import React, { Component } from "react"
import PropTypes from "proptypes"

class JoinForm extends Component {
  static propTypes = {
    onLogin: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    this.input = React.createRef()
  }

  handleLogin = ev => {
    ev.preventDefault()
    const playerName = this.input.current.value
    this.props.onLogin(playerName)
  }

  render() {
    return (
      <form id="join-form">
        <input
          id="player"
          ref={this.input}
          placeholder="Player Name (new or existing)"
        />
        <button id="connect" onClick={this.handleLogin}>
          Connect
        </button>
      </form>
    )
  }
}

export default JoinForm
