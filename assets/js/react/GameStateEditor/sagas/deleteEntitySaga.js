import "regenerator-runtime/runtime"
import { takeLatest, put, call } from "redux-saga/effects"

import {
  DELETE_ENTITY,
  deleteEntitySuccess,
  deleteEntityFailure
} from "../actions/gameStateEditor"

import { addFlashMessage } from "../../shared/actions/flashMessage"
import { fetchEntities } from "../actions/gameStateEditor"

import api from "../../api"

function* removeEntity(action) {
  console.log("REMOVE", action)
  try {
    const id = action.data
    const response = yield call(api.entities.destroy(id))
    yield put(deleteEntitySuccess(response.data))
    yield put(
      addFlashMessage({
        type: "info",
        text: `Success: ${JSON.stringify(response.data.message)}`
      })
    )
    yield put(fetchEntities())
  } catch (e) {
    console.error("Entity not removed", e)
    yield put(deleteEntityFailure(e.response.data))
    yield put(
      addFlashMessage({
        type: "error",
        text: `Failed to remove entity: ${JSON.stringify(e.response.data)}`
      })
    )
  }
}

export default function* onDeleteEntity() {
  yield takeLatest(DELETE_ENTITY, removeEntity)
}
