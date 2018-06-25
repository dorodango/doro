import React, { Component } from "react"
import { pipe, pick, prop, all, prepend, path, map, identity } from "ramda"
import classnames from "classnames"
import Select from "react-select"

class EntityForm extends Component {
  constructor(props) {
    super(props)
    const entity = this.props.entity || {}
    if (!entity.name) {
      entity.name = entity.id
    }
    this.state = { entity: this.props.entity || { props: {} } }
  }

  handleChangeBehaviors = behaviors => {
    const currentState = this.state
    this.setState({
      entity: {
        ...currentState.entity,
        behaviors: map(prop("value"), behaviors),
      },
    })
  }

  handleChangePropsDropdown = fieldname => {
    return selectedValue => {
      const currentState = this.state
      this.setState({
        entity: {
          ...currentState.entity,
          props: {
            ...currentState.entity.props,
            [fieldname]: selectedValue.value,
          },
        },
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
        name: newName,
      },
    })
  }

  handleChange = ev => {
    const currentState = this.state
    this.setState({
      entity: {
        ...currentState.entity,
        [ev.target.name]: ev.target.value,
      },
    })
  }

  handleChangeProps = ev => {
    const currentState = this.state
    this.setState({
      entity: {
        ...currentState.entity,
        props: {
          ...currentState.entity.props,
          [ev.target.name]: ev.target.value,
        },
      },
    })
  }

  handleAdd = ev => {
    this.props.add(this.state.entity)
  }

  handleClear = ev => {
    this.setState({ entity: null })
  }

  valid = () => {
    const requiredPaths = [["id"], ["props", "description"]]
    return all(pth => path(pth, this.state.entity), requiredPaths)
  }

  render() {
    const { entity } = this.state
    const { displayOnly, availableEntities, availableBehaviors } = this.props
    const entitiesForSelect = prepend(
      { value: "", label: "none" },
      map(dest => ({ value: dest, label: dest }), availableEntities || [])
    )
    return (
      <div
        className={classnames("EntityForm", { "display-only": displayOnly })}
      >
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
            options={availableBehaviors}
            onChange={this.handleChangeBehaviors}
          />
        </div>
        <div className="form-row">
          <label className="form-label">Location</label>
          <Select
            name="location"
            className="form-input"
            value={entity.props.location}
            options={entitiesForSelect}
            onChange={this.handleChangePropsDropdown("location")}
          />
        </div>
        <div className="form-row">
          <label className="form-label">Destination</label>
          <Select
            name="destination_id"
            className="form-input"
            value={entity.props.destination_id}
            options={entitiesForSelect}
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

export default EntityForm
