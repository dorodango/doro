import fetchAvailableBehaviorsSaga from "../GameStateEditor/sagas/fetchAvailableBehaviorsSaga"
import fetchEntitiesSaga from "../GameStateEditor/sagas/fetchEntitiesSaga"
import downloadEntitiesSaga from "../GameStateEditor/sagas/downloadEntitiesSaga"
import addEntitySaga from "../GameStateEditor/sagas/addEntitySaga"
import gameChannelSaga from "../shared/sagas/gameChannelSaga"

export default [
  fetchAvailableBehaviorsSaga,
  fetchEntitiesSaga,
  downloadEntitiesSaga,
  addEntitySaga,
  gameChannelSaga
]
