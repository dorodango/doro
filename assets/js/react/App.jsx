import React, { Component } from "react"
import PropTypes from "prop-types"

import GameStateEditor from "./GameStateEditor/GameStateEditor"
import GamePlayer from "./GamePlayer/GamePlayer"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"

import { editEntity, closeEditPane } from "./actions/app"

class App extends Component {
  static propTypes = {
    editEntity: PropTypes.func.isRequired,
    showEditPane: PropTypes.bool,
    closeEditPane: PropTypes.func.isRequired
  }

  static defaultProps = {
    showEditPane: false
  }

  handleToggleEditPane = ev => {
    ev.preventDefault()
    if (this.props.showEditPane) {
      this.props.closeEditPane()
    } else {
      this.props.editEntity()
    }
  }

  render() {
    const { showEditPane } = this.props
    return (
      <div className="doro">
        <main className="doro-main">
          <div className="doro-main__controls">
            <button
              className="doro-main--toggle button"
              onClick={this.handleToggleEditPane}
            >
              :P
            </button>
          </div>
          <GamePlayer />
        </main>
        <aside className="doro-aside" hidden={!showEditPane}>
          {showEditPane && (
            <GameStateEditor toggleEditor={this.handleToggleEditPane} />
          )}
        </aside>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  showEditPane: state.app.showEditPane
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      closeEditPane,
      editEntity
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(App)

export { App }
export default connectedComponent
