import "regenerator-runtime/runtime"
import { takeLatest, put, call } from "redux-saga/effects"

import {
  ADD_ENTITY,
  addEntitySuccess,
  addEntityFailure
} from "../actions/entityForm"
import { convertBehaviorsToArray } from "../selectors/entityForm"

import { addFlashMessage } from "../../shared/actions/flashMessage"
import { fetchEntities } from "../actions/gameStateEditor"

import api from "../../api"

function* add(action) {
  try {
    /** incoming data has behaviors keyed by type in a hash.  Convert them for the controller */
    const params = convertBehaviorsToArray(action.data)
    const response = yield call(api.entities.create, params)
    yield put(addEntitySuccess(response.data))
    yield put(
      addFlashMessage({
        type: "info",
        text: `Success: ${JSON.stringify(response.data.message)}`
      })
    )
    yield put(fetchEntities())
  } catch (e) {
    console.error("Entity not added", e)
    yield put(addEntityFailure(e.response.data))
    yield put(
      addFlashMessage({
        type: "error",
        text: `Failed to add entity: ${JSON.stringify(e.response.data)}`,
      })
    )
  }
}

export default function* onAddEntity() {
  yield takeLatest(ADD_ENTITY, add)
}
