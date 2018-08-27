export const FETCH_AVAILABLE_BEHAVIORS = "entityForm/FETCH_AVAILABLE_BEHAVIORS"
export const FETCH_AVAILABLE_BEHAVIORS_SUCCESS =
  "entityForm/FETCH_AVAILABLE_BEHAVIORS_SUCCESS"
export const FETCH_AVAILABLE_BEHAVIORS_FAILURE =
  "entityForm/FETCH_AVAILABLE_BEHAVIORS_FAILURE"

export const ADD_ENTITY = "entityForm/ADD_ENTITY"
export const ADD_ENTITY_SUCCESS = "entityForm/ADD_ENTITY_SUCCESS"
export const ADD_ENTITY_FAILURE = "entityForm/ADD_ENTITY_FAILURE"

export const fetchAvailableBehaviors = data => ({
  type: FETCH_AVAILABLE_BEHAVIORS,
  data
})
export const fetchAvailableBehaviorsSuccess = data => ({
  type: FETCH_AVAILABLE_BEHAVIORS_SUCCESS,
  data
})
export const fetchAvailableBehaviorsFailure = data => ({
  type: FETCH_AVAILABLE_BEHAVIORS_FAILURE,
  data
})

export const addEntity = data => ({ type: ADD_ENTITY, data })
export const addEntitySuccess = data => ({ type: ADD_ENTITY_SUCCESS, data })
export const addEntityFailure = data => ({ type: ADD_ENTITY_FAILURE, data })
