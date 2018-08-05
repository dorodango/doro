import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import { isEmpty } from "ramda"

import { sendCommand } from "../../shared/actions/channel"

class CommandInput extends Component {
  static propTypes = {
    sendCommand: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    this.input = React.createRef()
    this.history = []
    this.historyIndex = -1
  }

  handleKeyDown = ev => {
    let cmd
    switch (ev.key) {
      case "Enter":
        cmd = this.input.current.value
        if (!isEmpty(cmd)) {
          this.props.sendCommand({ cmd })
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
      <div className="CommandInput">
        <input
          onKeyDown={this.handleKeyDown}
          className="CommandInput__input"
          ref={this.input}
          placeholder="Enter a command"
          autoFocus={true}
        />
      </div>
    )
  }
}

const mapStateToProps = state => ({
  userSession: state.userSession,
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      sendCommand,
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(CommandInput)

export { CommandInput }
export default connectedComponent
