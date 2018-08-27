import "regenerator-runtime/runtime"
import { takeLatest, put, call } from "redux-saga/effects"

import {
  ADD_ENTITY,
  addEntitySuccess,
  addEntityFailure
} from "../actions/entityForm"
import { addFlashMessage } from "../../shared/actions/flashMessage"
import { fetchEntities } from "../actions/gameStateEditor"

import api from "../../api"

function* add(action) {
  try {
    const response = yield call(api.entities.create, action.data)
    yield put(addEntitySuccess(response.data))
    yield put(
      addFlashMessage({
        type: "info",
        text: `Success: ${JSON.stringify(response.data.message)}`
      })
    )
    yield put(fetchEntities())
  } catch (e) {
    console.log("Not Added", e)
    yield put(addEntityFailure(e.response.data))
  }
}

export default function* onAddEntity() {
  yield takeLatest(ADD_ENTITY, add)
}
