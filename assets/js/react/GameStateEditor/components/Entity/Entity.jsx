import React from "react"
import PropTypes from "prop-types"

import { isEmpty } from "../../../shared/utils/utilities"

const highlightedJsonObject = (entity, highlightTerm) => {
  const json = JSON.stringify(entity, null, 2)
  if (isEmpty(highlightTerm)) {
    return json
  } else {
    return json.replace(new RegExp(highlightTerm, "mg"), `*${highlightTerm}*`)
  }
}

const renderEditButton = (entity, handleEdit) => (
  <button className="Entity__edit button" onClick={handleEdit}>
    Edit
  </button>
)

const renderDeleteButton = (entity, handleDelete) => {
  if (entity.src) {
    return ""
  }
  return (
    <button className="Entity__delete button" onClick={handleDelete}>
      X
    </button>
  )
}

const Entity = ({ entity, handleEdit, handleDelete, highlightTerm }) => {
  return (
    <div className="Entity">
      <div className="Entity__actions">
        {renderEditButton(entity, handleEdit)}
        {renderDeleteButton(entity, handleDelete)}
      </div>
      <pre>
        <code>{highlightedJsonObject(entity, highlightTerm)}</code>
      </pre>
    </div>
  )
}

Entity.propTypes = {
  entity: PropTypes.object.isRequired,
  handleEdit: PropTypes.func.isRequired,
  handleDelete: PropTypes.func.isRequired,
  highlightTerm: PropTypes.string
}

Entity.defaultProps = {
  highlightTerm: ""
}

export default Entity
