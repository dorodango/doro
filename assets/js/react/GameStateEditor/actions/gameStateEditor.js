export const FETCH_ENTITIES = "gameStateEditor/FETCH_ENTITIES"
export const FETCH_ENTITIES_SUCCESS = "gameStateEditor/FETCH_ENTITIES_SUCCESS"
export const FETCH_ENTITIES_FAILURE = "gameStateEditor/FETCH_ENTITIES_FAILURE"

export const DOWNLOAD_ENTITIES = "gameStateEditor/DOWNLOAD_ENTITIES"

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
