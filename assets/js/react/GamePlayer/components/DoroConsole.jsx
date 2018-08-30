import React, { Component } from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"

import DoroOutput from "./DoroOutput"

class DoroConsole extends Component {
  static propTypes = {
    userSession: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props)
  }

  render() {
    const { userSession } = this.props
    return (
      <div className="DoroConsole">
        <div className="DoroConsole__player">{userSession.playerName}</div>
        <DoroOutput player={userSession} />
      </div>
    )
  }
}

const mapStateToProps = state => ({
  userSession: state.userSession
})

const mapDispatchToProps = dispatch => bindActionCreators({}, dispatch)

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(DoroConsole)

export { DoroConsole }
export default connectedComponent
