export const FETCH_ENTITIES = "gameStateEditor/FETCH_ENTITIES"
export const FETCH_ENTITIES_SUCCESS = "gameStateEditor/FETCH_ENTITIES_SUCCESS"
export const FETCH_ENTITIES_FAILURE = "gameStateEditor/FETCH_ENTITIES_FAILURE"

export const DOWNLOAD_ENTITIES = "gameStateEditor/DOWNLOAD_ENTITIES"

export const DELETE_ENTITY = "gameStateEditor/DELETE_ENTITY"
export const DELETE_ENTITY_SUCCESS = "gameStateEditor/DELETE_ENTITY_SUCCESS"
export const DELETE_ENTITY_FAILURE = "gameStateEditor/DELETE_ENTITY_FAILURE"

export const ACTIVATE_TAB = "gameStateEditor/ACTIVATE_TAB"

export const fetchEntities = data => ({ type: FETCH_ENTITIES, data })
export const fetchEntitiesSuccess = data => ({
  type: FETCH_ENTITIES_SUCCESS,
  data
})
export const fetchEntitiesFailure = data => ({
  type: FETCH_ENTITIES_FAILURE,
  data
})

export const downloadEntities = data => ({ type: DOWNLOAD_ENTITIES, data })

export const deleteEntity = data => ({ type: DELETE_ENTITY, data })
export const deleteEntitySuccess = data => ({
  type: DELETE_ENTITY_SUCCESS,
  data
})
export const deleteEntityFailure = data => ({
  type: DELETE_ENTITY_FAILURE,
  data
})

export const activateTab = data => ({ type: ACTIVATE_TAB, data })
