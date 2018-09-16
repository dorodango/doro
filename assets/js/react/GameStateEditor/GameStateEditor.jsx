import React, { Component } from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import { filter } from "ramda"

import { isEmpty } from "../shared/utils/utilities"
import FlashMessage from "../shared/components/Flash/Flash"
import CurrentEntities from "./components/CurrentEntities/CurrentEntities"
import EntityForm from "./components/EntityForm/EntityForm"
import TabSet from "../shared/components/TabSet/TabSet"
import {
  fetchEntities,
  downloadEntities,
  activateTab
} from "./actions/gameStateEditor"

class GameStateEditor extends Component {
  static propTypes = {
    entities: PropTypes.arrayOf(PropTypes.object),
    locations: PropTypes.array,
    loading: PropTypes.bool
  }

  static defaultProps = {
    entities: [],
    locations: [],
    loading: false
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
    this.props.fetchEntities()
    this.setState({entity})
  }

  handleDownloadNewEntities = _ev => {
    const { entities } = this.props
    this.props.downloadEntities({
      entities: filter(entry => !entry.src, entities),
      filename: "new-entities.json"
    });
  }

  handleDownloadEntities = _ev => {
    const { entities } = this.props
    this.props.downloadEntities({ entities: entities })
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
        component: <CurrentEntities entities={entities} />
      }
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
                className="GameStateEditor__download GameStateEditor__download--all button"
                onClick={this.handleDownloadEntities}
              >
                Download All Entities
              </button>
              <button
                className="GameStateEditor__download GameStateEditor__download--new button"
                onClick={this.handleDownloadNewEntities}
              >
                Download New Entities
              </button>
            </div>
          </header>
          <div>{this.renderTabs()}</div>
        </section>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  entities: state.gameStateEditor.entities,
  locations: state.gameStateEditor.locations,
  loading: state.gameStateEditor.loading
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      fetchEntities,
      downloadEntities
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(GameStateEditor)

export { GameStateEditor }
export default connectedComponent
