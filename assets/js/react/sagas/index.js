import fetchAvailableBehaviorsSaga from "../GameStateEditor/sagas/fetchAvailableBehaviorsSaga"
import fetchEntitiesSaga from "../GameStateEditor/sagas/fetchEntitiesSaga"
import addEntitySaga from "../GameStateEditor/sagas/addEntitySaga"
import joinChannelSaga from "../shared/sagas/joinChannelSaga"

export default [
  fetchAvailableBehaviorsSaga,
  fetchEntitiesSaga,
  addEntitySaga,
  joinChannelSaga,
]
