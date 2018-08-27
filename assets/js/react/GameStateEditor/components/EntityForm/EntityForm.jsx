import React, { Component } from "react"
import PropTypes from "proptypes"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import {
  all,
  compose,
  contains,
  filter,
  find,
  identity,
  isEmpty,
  map,
  path,
  pipe,
  prepend,
  prop,
  sort,
  sortBy,
  toLower,
  uniq
} from "ramda"
import classnames from "classnames"
import Select from "react-select"

import Spinner from "../../../shared/components/Spinner/Spinner"
import { fetchEntities } from "../../actions/gameStateEditor"
import { fetchAvailableBehaviors, addEntity } from "../../actions/entityForm"
import {
  addFlashMessage,
  clearFlashMessage
} from "../../../shared/actions/flashMessage"

class EntityForm extends Component {
  static propTypes = {
    availableBehaviors: PropTypes.arrayOf(PropTypes.string),
    locations: PropTypes.arrayOf(PropTypes.string),
    fetchAvailableBehaviors: PropTypes.func.isRequired,
    addEntity: PropTypes.func.isRequired
  }

  static defaultProps = {
    availableBehaviors: [],
    locations: []
  }

  constructor(props) {
    super(props)

    const entity = this.props.entity || {}
    if (!entity.name) {
      entity.name = entity.id
    }
    this.state = { entity: this.props.entity || { props: {} } }
  }

  componentDidMount() {
    if (isEmpty(this.props.availableBehaviors)) {
      this.props.fetchAvailableBehaviors()
    }
  }

  handleChangeBehaviors = behaviors => {
    const currentState = this.state
    this.setState({
      entity: {
        ...currentState.entity,
        behaviors: map(prop("value"), behaviors)
      }
    })
  }

  handleChangePropsDropdown = fieldName => {
    return selectedValue => {
      const currentState = this.state
      this.setState({
        entity: {
          ...currentState.entity,
          props: {
            ...currentState.entity.props,
            [fieldName]: selectedValue.value
          }
        }
      })
    }
  }

  handleChangeName = ev => {
    const currentState = this.state
    const newName = ev.target.value || ""
    this.setState({
      entity: {
        ...currentState.entity,
        id: newName
          .trim()
          .replace(/[^\w\d]+/gi, "-")
          .toLowerCase(),
        name: newName
      }
    })
  }

  handleChange = ev => {
    const currentState = this.state
    this.setState({
      entity: {
        ...currentState.entity,
        [ev.target.name]: ev.target.value
      }
    })
  }

  handleChangeProps = ev => {
    const currentState = this.state
    this.setState({
      entity: {
        ...currentState.entity,
        props: {
          ...currentState.entity.props,
          [ev.target.name]: ev.target.value
        }
      }
    })
  }

  handleAdd = ev => {
    ev.preventDefault()
    this.props.addEntity(this.state.entity)
  }

  handleClear = _ev => {
    this.setState({ entity: null })
  }

  valid = () => {
    const requiredPaths = [["id"], ["props", "description"]]
    return all(pth => path(pth, this.state.entity), requiredPaths)
  }

  render() {
    const { availableBehaviors, locations, loading } = this.props

    const entity = this.state.entity

    if (loading) {
      return <Spinner />
    }

    const forSelect = val => ({ label: val, value: val })
    const sortByLabel = sortBy(
      compose(
        toLower,
        prop("label")
      )
    )
    const behaviorsForSelect = pipe(
      map(forSelect),
      sortByLabel
    )(availableBehaviors)
    const locationsForSelect = pipe(
      map(forSelect),
      sortByLabel
    )(locations)

    return (
      <div className="EntityForm">
        <div className="form-row">
          <label required={true} className="form-label">
            Entity Name
          </label>
          <input
            required={true}
            className="form-input"
            value={entity.name}
            onChange={this.handleChangeName}
            type="text"
            name="name"
          />
        </div>
        <div className="form-row">
          <label required={true} className="form-label">
            Entity Id
          </label>
          <input
            required={true}
            className="form-input"
            value={entity.id}
            onChange={this.handleChange}
            type="text"
            name="id"
          />
        </div>
        <div className="form-row">
          <label required={true} className="form-label">
            Description
          </label>
          <textarea
            required={true}
            className="form-input"
            onChange={this.handleChangeProps}
            value={entity.props.description}
            name="description"
          />
        </div>
        <div className="form-row">
          <label className="form-label">Behaviors</label>
          <Select
            name="behaviors"
            className="form-input"
            multi={true}
            removeSelected={true}
            value={entity.behaviors}
            options={behaviorsForSelect}
            onChange={this.handleChangeBehaviors}
          />
        </div>
        <div className="form-row">
          <label className="form-label">Location</label>
          <Select
            name="location"
            className="form-input"
            value={entity.props.location}
            options={locationsForSelect}
            onChange={this.handleChangePropsDropdown("location")}
          />
        </div>
        <div className="form-row">
          <label className="form-label">Destination</label>
          <Select
            name="destination_id"
            className="form-input"
            value={entity.props.destination_id}
            options={locationsForSelect}
            onChange={this.handleChangePropsDropdown("destination_id")}
          />
        </div>
        <div className="form-actions">
          <button disabled={!this.valid()} onClick={this.handleAdd}>
            Add
          </button>
          <button onClick={this.handleClear}>Clear</button>
        </div>
      </div>
    )
  }
}

// this might go in a selectors file
const getId = prop("id")
const hasNoLocation = entity => path(["props", "location"], entity) == null
const isNotAPlayer = entity => !contains("player", entity.behaviors)
const isNotPrivate = entity => !/^_/.test(getId(entity))
const extractLocationsFromEntities = pipe(
  filter(hasNoLocation),
  filter(isNotAPlayer),
  filter(isNotPrivate),
  map(getId)
)

const mapStateToProps = state => {
  return {
    availableBehaviors: state.entityForm.availableBehaviors,
    locations: extractLocationsFromEntities(
      state.gameStateEditor.entities || []
    ),
    loading: state.entityForm.loading
  }
}

const mapDispatchToProps = dispatch =>
  bindActionCreators(
    {
      fetchAvailableBehaviors,
      addEntity,
      addFlashMessage,
      clearFlashMessage
    },
    dispatch
  )

const connectedComponent = connect(
  mapStateToProps,
  mapDispatchToProps
)(EntityForm)

export { EntityForm }
export default connectedComponent
