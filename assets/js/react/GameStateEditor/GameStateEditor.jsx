import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import download from "downloadjs"
import { isEmpty } from "ramda"

import FlashMessage from "../shared/components/Flash/Flash"
import Spinner from "../shared/components/Spinner/Spinner"
import CurrentEntities from "./components/CurrentEntities/CurrentEntities"
import EntityForm from "./components/EntityForm/EntityForm"
import Entity from "./components/Entity/Entity"
import TabSet from "../shared/components/TabSet/TabSet"
import { fetchEntities } from "./actions/gameStateEditor"

class GameStateEditor extends Component {
  static propTypes = {
    entities: PropTypes.arrayOf(PropTypes.object),
  }

  static defaultProps = {
    entities: [],
  }

  constructor(props) {
    super(props)
  }

  componentDidMount() {
    if (isEmpty(this.props.entities)) {
      this.props.fetchEntities()
    }
  }

  handleEdit = entity => {
    this.setState({
      entity: entity,
    })
  }

  handleDelete = entity => {
    const { entities } = this.state
    this.setState({
      entities: filter(entry => entry.id !== entity.id, entities),
    })
  }

  handleDownload = _ev => {
    download(
      JSON.stringify({ entities: this.state.entities }),
      "game_state.json",
      "application/json"
    )
  }

  handleUpdateWorld = _ev => {
    /* axios
     *   .post("/api/game_state", { entities: this.state.entities })
     *   .then(
     *     response => console.warn("[Game State Reload] success", response),
     *     error => console.warn("[Game State Reload] Failure", error)
     *   )*/
  }

  handleReset = _ev => {
    /* axios
     *   .put("/api/game_state")
     *   .then(
     *     response => console.warn("[Game State Reset] success", response),
     *     error => console.warn("[Game State Reset] Failure", error)
     *   )*/
  }

  handleClear = _ev => {
    this.setState({
      entities: [],
    })
  }

  renderTabs = () => {
    const entities = []

    const tabs = [
      {
        name: "Editor",
        component: (
          <div className="GameStateEditor__addNew">
            <EntityForm />
          </div>
        ),
      },
      {
        name: "Entities",
        component: <CurrentEntities entities={entities} />,
      },
    ]
    return <TabSet tabs={tabs} />
  }

  render() {
    const { entities } = this.props
    return (
      <div className="GameStateEditor">
        <FlashMessage />
        <section className="GameStateEditor-current">
          <header>
            <div className="GameStateEditor__actions">
              <button
                className="GameStateEditor__reload button"
                onClick={this.handleUpdateWorld}
              >
                Update World
              </button>
              <button
                className="GameStateEditor__reset button"
                onClick={this.handleReset}
              >
                Reset
              </button>
              <button
                className="GameStateEditor__download button"
                onClick={this.handleDownload}
              >
                Download
              </button>
            </div>
          </header>
          <main>{this.renderTabs()}</main>
        </section>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  entities: state.gameStateEditor.entities,
  locations: state.gameStateEditor.locations,
  loading: state.gameStateEditor.loading,
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      fetchEntities,
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(GameStateEditor)

export { GameStateEditor }
export default connectedComponent
