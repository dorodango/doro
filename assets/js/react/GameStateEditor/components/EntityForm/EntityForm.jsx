import React, { Component } from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux"
import { bindActionCreators } from "redux"
import { mergeDeepRight, omit, assocPath } from "ramda"
import { map as mapIndexed, get, every as all } from "lodash"
import { flow, map, sortBy } from "lodash/fp"
import Select from "react-select"

import { isEmpty } from "../../../shared/utils/utilities"
import Spinner from "../../../shared/components/Spinner/Spinner"
import { fetchAvailableBehaviors, addEntity } from "../../actions/entityForm"
import {
  addFlashMessage,
  clearFlashMessage
} from "../../../shared/actions/flashMessage"

const emptyEntity = {
  id: "",
  name: "",
  props: {},
  behaviors: { visible: { description: "" } }
}

/** local helpers */
const forSelect = val => ({ label: val, value: val })

const getLowerCaseLabel = val => val.label.toLowerCase()
const sortValuesForDropdown = values => {
  return flow(
    map(forSelect),
    sortBy(getLowerCaseLabel)
  )(values)
}

class EntityForm extends Component {
  static propTypes = {
    availableBehaviors: PropTypes.arrayOf(PropTypes.string),
    behaviorShapes: PropTypes.object,
    locations: PropTypes.arrayOf(PropTypes.string),
    fetchAvailableBehaviors: PropTypes.func.isRequired,
    addEntity: PropTypes.func.isRequired,
    entity: PropTypes.object,
    editStarted: PropTypes.instanceOf(Date)
  }

  static defaultProps = {
    availableBehaviors: [],
    locations: [],
    entity: emptyEntity
  }

  constructor(props) {
    super(props)
  }

  componentDidMount() {
    if (isEmpty(this.props.availableBehaviors)) {
      this.props.fetchAvailableBehaviors()
    }
  }

  render() {
    const { availableBehaviors, behaviorShapes, loading, entity } = this.props
    if (loading || isEmpty(availableBehaviors) || isEmpty(behaviorShapes)) {
      return <Spinner />
    }
    return (
      <_EntityForm {...this.props} key={(entity && entity.id) || "newEntity"} />
    )
  }
}

class _EntityForm extends Component {
  constructor(props) {
    super(props)
    this.state = emptyEntity
  }

  componentDidMount() {
    if (!isEmpty(this.props.entity)) {
      this.setState({ ...this.props.entity })
    }
  }

  handleRemoveBehavior = ev => {
    const currentState = this.state
    this.setState({
      behaviors: omit([ev.target.name], this.state.behaviors)
    })
  }

  handleAddNewBehavior = selectedOption => {
    const currentState = this.state
    this.setState(
      mergeDeepRight(currentState, {
        behaviors: { [selectedOption.value]: {} }
      })
    )
  }

  handleChangeLocation = selectedOption =>
    this.setFieldState("props.location", selectedOption.value)

  handleChangeName = ev => {
    const currentState = this.state
    const newName = ev.target.value || ""
    this.setState(
      mergeDeepRight(currentState, {
        id: newName
          .trim()
          .replace(/[^\w\d]+/gi, "-")
          .toLowerCase(),
        name: newName
      })
    )
  }

  getFieldState = fieldName => {
    return get(this.state, fieldName)
  }

  setFieldState = (fieldName, value) => {
    const currentState = this.state
    const nameBits = fieldName.split(".")
    const update = assocPath(nameBits, value)({})
    this.setState(mergeDeepRight(currentState, update))
  }

  handleChange = ev => this.setFieldState(ev.target.name, ev.target.value)

  handleChangeDestination = fieldName => selectedOption =>
    this.setFieldState(fieldName, selectedOption.value)

  handleAdd = ev => {
    ev.preventDefault()
    this.props.addEntity(this.state)
  }

  handleClear = _ev => {
    this.setState(emptyEntity)
  }

  valid = () => {
    const requiredPaths = ["id", "name"]
    return (
      all(requiredPaths, pth => !isEmpty(get(this.state, pth))) &&
      !isEmpty(Object.keys(this.state.behaviors))
    )
  }

  determineFieldType = (fieldName, value) => {
    if (fieldName.match(/\.destinationId$/)) {
      return {
        fieldType: "destination",
        changeCallback: this.handleChangeDestination(fieldName)
      }
    }
    return { fieldType: "text", changeCallback: this.handleChange }
  }

  renderFieldRow = (name, label, input) => {
    return (
      <div className="form-row--secondary" key={name}>
        <label className="form-label--secondary">{label}</label>
        {input}
      </div>
    )
  }

  renderDestinationField = (name, label, changeCallback) => {
    const locationsForSelect = this.locationDropdownValues()

    return this.renderFieldRow(
      name,
      label,
      <Select
        name={name}
        value={this.getFieldState(name)}
        className="form-input"
        options={locationsForSelect}
        onChange={changeCallback}
      />
    )
  }

  renderTextField = (name, label, changeCallback) => {
    return this.renderFieldRow(
      name,
      label,
      <input
        className="form-input"
        name={name}
        value={this.getFieldState(name)}
        onChange={changeCallback}
        type="text"
      />
    )
  }

  renderBehaviorField = (behavior, field, value, index) => {
    const fieldName = `behaviors.${behavior}.${field}`
    const fieldLabel = `${behavior}: ${field}`
    const { fieldType, changeCallback } = this.determineFieldType(
      fieldName,
      value
    )
    switch (fieldType) {
      case "destination":
        return this.renderDestinationField(
          fieldName,
          fieldLabel,
          changeCallback
        )
        break
      default:
        return this.renderTextField(fieldName, fieldLabel, changeCallback)
    }
  }

  renderBehaviorFields = behavior => {
    const { behaviorShapes } = this.props
    const shape = behaviorShapes[behavior]
    if (isEmpty(shape)) {
      return <div className="form-input">No editable properties</div>
    }

    return Object.keys(shape).map((field, value, index) =>
      this.renderBehaviorField(behavior, field, value, index)
    )
  }

  renderBehaviorForm = (behaviorAttrs, behavior) => {
    if (!behavior) {
      return ""
    }

    return (
      <div className="form-row" key={behavior}>
        <label className="form-label">Behavior: {behavior}</label>
        {this.renderBehaviorFields(behavior)}
        <button
          className="EntityForm__remove-behavior button"
          title="Remove #{behavior}"
          name={behavior}
          onClick={this.handleRemoveBehavior}
        >
          x
        </button>
      </div>
    )
  }

  renderAddNewBehavior = () => {
    const { availableBehaviors } = this.props
    const behaviorsForSelect = sortValuesForDropdown(availableBehaviors)

    return (
      <div className="form-row">
        <label className="form-label">Add New Behavior</label>
        <Select
          name="new_behavior"
          className="form-input"
          options={behaviorsForSelect}
          onChange={this.handleAddNewBehavior}
        />
      </div>
    )
  }

  renderBehaviors = () => {
    const behaviors = this.state.behaviors
    return mapIndexed(behaviors, this.renderBehaviorForm)
  }

  locationDropdownValues = () => sortValuesForDropdown(this.props.locations)

  render() {
    const { id, name, props } = this.state

    const originalEntity = this.props.entity

    const locationsForSelect = this.locationDropdownValues()

    return (
      <div className="EntityForm" key={originalEntity.id}>
        <div className="form-row">
          <label required={true} className="form-label">
            Entity Name
          </label>
          <input
            required={true}
            className="form-input"
            value={name}
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
            value={id}
            onChange={this.handleChange}
            type="text"
            name="id"
          />
        </div>
        <div className="form-row">
          <label className="form-label">Location</label>
          <Select
            name="props.location"
            className="form-input"
            value={props.location}
            options={locationsForSelect}
            onChange={this.handleChangeLocation}
          />
        </div>
        {this.renderBehaviors()}
        {this.renderAddNewBehavior()}
        <div className="form-actions">
          <button
            disabled={!this.valid()}
            onClick={this.handleAdd}
            className="button EntityForm__submit-entity"
          >
            Add/Update
          </button>
          <button
            onClick={this.handleClear}
            className="button EntityForm__clear-entity"
          >
            Clear
          </button>
        </div>
        <div className="EntityForm__state">
          <pre>{JSON.stringify(this.state, null, 2)}</pre>
        </div>
      </div>
    )
  }
}

const mapStateToProps = state => {
  return {
    availableBehaviors: state.entityForm.availableBehaviors,
    behaviorShapes: state.entityForm.behaviorShapes,
    locations: state.gameStateEditor.locations,
    loading: state.entityForm.loading,
    editStarted: state.entityForm.editStarted,
    entity: state.entityForm.entity || emptyEntity
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
