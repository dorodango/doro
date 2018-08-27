import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import { map, addIndex, isEmpty, isNil, filter, any, path } from "ramda"

import Entity from "../Entity/Entity"
import { isArray } from "util"
import { fetchEntities } from "../../actions/gameStateEditor"

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

  handleSearch = ev => {
    const query = ev.target.value.trim()
    let filteredEntities = this.props.entities

    if (query && !isEmpty(query)) {
      const fieldMatcher = (field, query) => entity => {
        const val = path(field.split("."), entity)
        if (val) {
          if (isArray(val)) {
            return any(v => v.match(query), val)
          }
          return val.match(query)
        }
      }

      const fieldsMatcher = (fields, query) => {
        return entity =>
          any(field => {
            const result = fieldMatcher(field, query)(entity)
            return result
          }, fields)
      }
      const fields = ["id", "name", "name_tokens"]
      filteredEntities = filter(
        fieldsMatcher(fields, query),
        this.props.entities
      )
    }
    this.setState({
      query: query,
      filteredEntities: filteredEntities
    })
  }

  handleEdit = () => {}
  handleDelete = () => {}

  render() {
    let mapIndexed = addIndex(map)
    let { filteredEntities, query } = this.state
    filteredEntities = filteredEntities || this.props.entities
    return (
      <div className="CurrentEntities">
        <form>
          <input
            className="CurrentEntites__search-input"
            type="text"
            onChange={this.handleSearch}
            placeholder="filter..."
          />
        </form>
        <div className="CurrentEntities__search-matches">
          Matches: {filteredEntities.length}
        </div>
        {mapIndexed((elem, idx) => (
          <Entity
            key={idx}
            entity={elem}
            handleEdit={this.handleEdit}
            handleDelete={this.handleDelete}
            highlightTerm={query}
          />
        ))(filteredEntities)}
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
      fetchEntities
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(CurrentEntities)

export { CurrentEntities }
export default connectedComponent
