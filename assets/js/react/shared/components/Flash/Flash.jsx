import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"

import { removeFlashMessage } from "../../../shared/actions/flashMessage"

class Flash extends Component {
  static propTypes = {
    type: PropTypes.string,
    text: PropTypes.string
  }

  componentDidMount() {
    setTimeout(this.props.removeFlashMessage, 7000)
  }

  handleClose = ev => {
    ev.preventDefault()
    this.props.removeFlashMessage()
  }

  render() {
    const { text, type } = this.props
    const clazzName = `Flash Flash--${type}`
    if (text && type) {
      return (
        <div className={clazzName} onClick={this.handleClose}>
          <div className="Flash__close-button">x</div>
          <div className="Flash__message">{text}</div>
        </div>
      )
    }
    return null
  }
}

const mapStateToProps = state => ({ ...state.flashMessage })

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      removeFlashMessage
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(Flash)

export { Flash }
export default connectedComponent
