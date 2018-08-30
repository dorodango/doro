import React, { Component, Fragment } from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"

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

  loggedIn = () => this.props.userSession && this.props.userSession.playerId

  onLogin = playerName => {
    this.props.sendHello(playerName)
  }

  render() {
    const { userSession } = this.props
    return (
      <div className="GamePlayer">
        {!this.loggedIn() && <JoinForm onLogin={this.onLogin} />}
        {this.loggedIn() && (
          <Fragment>
            <DoroConsole />
            <CommandInput />
          </Fragment>
        )}
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
      sendHello
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(GamePlayer)

export { GamePlayer }
export default connectedComponent
