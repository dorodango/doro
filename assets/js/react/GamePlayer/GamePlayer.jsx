import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"

import { configureChannel } from "../shared/channel"
import JoinForm from "./components/JoinForm"
import CommandInput from "./components/CommandInput"
import DoroConsole from "./components/DoroConsole"
import { sendHello } from "../shared/actions/channel"

class GamePlayer extends Component {
  static propTypes = {
    sendHello: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
  }

  /* join = playerName => {
   *   const currentState = this.state
   *   const cb = playerId => {
   *     const newState = { player: { playerName, playerId } }
   *     this.setState({ ...currentState, ...newState })
   *   }
   *   const ch = this.socket.channel(`hello:${playerName}`)
   *   ch.on("player_info", payload => cb(payload.player_id))
   *   ch.join()
   * }

   */
  loggedIn = () => ( this.props.userSession && this.props.userSession.playerId )

  onLogin = playerName => {
    this.props.sendHello(playerName)
  }

  render() {
    const {userSession} = this.props
    return (
      <div className="GamePlayer">
        {!this.loggedIn() && <JoinForm onLogin={this.onLogin} />}
        {this.loggedIn() && <DoroConsole /> }
        {this.loggedIn() && <CommandInput />}
      </div>
    )
  }
}

const mapStateToProps = state => ({
  userSession: state.userSession
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      sendHello,
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(GamePlayer)

export { GamePlayer }
export default connectedComponent