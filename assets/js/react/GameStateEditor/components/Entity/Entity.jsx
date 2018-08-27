import React from "react"
import PropTypes from "proptypes"
import { isEmpty, isNil } from "ramda"

const highlightedJsonObject = (entity, highlightTerm) => {
  const json = JSON.stringify(entity, null, 2)
  if (isEmpty(highlightTerm) || isNil(highlightTerm)) {
    return json
  } else {
    return json.replace(new RegExp(highlightTerm, "mg"), `*${highlightTerm}*`)
  }
}

const Entity = ({ entity, handleEdit, handleDelete, highlightTerm }) => {
  return (
    <div className="Entity">
      {/* <div className="Entity__actions">
        <button className="Entity__edit button" onClick={handleEdit}>
          Edit
        </button>
        <button className="Entity__delete button" onClick={handleDelete}>
          X
        </button>
      </div> */}
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
