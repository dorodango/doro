import React, { Component } from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import { isArray, some, filter, get, map } from "lodash"

import { isEmpty } from "../../../shared/utils/utilities"

import Entity from "../Entity/Entity"
import { fetchEntities, deleteEntity } from "../../actions/gameStateEditor"
import { editEntity } from "../../../actions/app"

class CurrentEntities extends Component {
  static propTypes = {
    entities: PropTypes.arrayOf(PropTypes.object)
  }

  static defaultProps = {
    entities: []
  }

  constructor(props) {
    super(props)
    this.state = {
      query: null
    }
  }

  componentDidMount() {
    if (isEmpty(this.props.entities)) {
      this.props.fetchEntities()
    }
  }

  filterEntities = (entities, query) => {
    let filteredEntities = entities || [];

    if (!isEmpty(query)) {
      const fieldMatcher = (field, query) => entity => {
        const val = get(entity, field)
        if (val) {
          if (isArray(val)) {
            return some(val, v => v.match(query))
          }
          return val.match(query)
        }
      }

      const fieldsMatcher = (fields, query) => {
        return entity =>
          some(fields, field => fieldMatcher(field, query)(entity))
      }

      const fields = ["id", "name", "name_tokens"]
      filteredEntities = filter(
        this.props.entities,
        fieldsMatcher(fields, query)
      )
    }
    return filteredEntities;
  }

  handleSearch = ev => {
    const query = ev.target.value.trim()
    this.setState({
      query: query
    })
  }

  handleEdit = (entity) => {
    return () => {
      this.props.editEntity({entity})
    }
  }

  handleDelete = (id) => {
    return () => {
      this.props.deleteEntity(id)
    }
  }

  render() {
    let { query } = this.state
    const filteredEntities = this.filterEntities(this.props.entities, query)
    return (
      <div className="CurrentEntities">
        <form>
          <input
            className="CurrentEntities__search-input"
            type="text"
            onChange={this.handleSearch}
            placeholder="filter..."
          />
        </form>
        <div className="CurrentEntities__search-matches">
          Matches: {filteredEntities.length}
        </div>
        {map(filteredEntities, (elem, idx) => (
          <Entity
            key={elem.id}
            entity={elem}
            handleEdit={this.handleEdit(elem)}
            handleDelete={this.handleDelete(elem.id)}
            highlightTerm={query}
          />
        ))}
      </div>
    )
  }
}

const mapStateToProps = state => ({
  entities: state.gameStateEditor.entities
})

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      fetchEntities,
      deleteEntity,
      editEntity
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(CurrentEntities)

export { CurrentEntities }
export default connectedComponent
