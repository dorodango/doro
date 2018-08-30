export const CLOSE_EDIT_PANE = "app/CLOSE_EDIT_PANE"
export const EDIT_ENTITY = "app/EDIT_ENTITY"

export const closeEditPane = data => ({ type: CLOSE_EDIT_PANE, data })
export const editEntity = data => ({ type: EDIT_ENTITY, data })
