import "regenerator-runtime/runtime"
import { takeLatest, put, call } from "redux-saga/effects"

import {
  FETCH_ENTITIES,
  fetchEntitiesSuccess,
  fetchEntitiesFailure
} from "../actions/gameStateEditor"

import api from "../../api"

function* fetch(_action) {
  try {
    const response = yield call(api.entities.index)
    yield put(fetchEntitiesSuccess(response.data))
  } catch (e) {
    yield put(fetchEntitiesFailure(e.response.data))
  }
}

export default function* onFetchRecords() {
  yield takeLatest(FETCH_ENTITIES, fetch)
}
