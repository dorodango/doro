import "regenerator-runtime/runtime"
import { takeLatest, put, call } from "redux-saga/effects"

import {
  FETCH_AVAILABLE_BEHAVIORS,
  fetchAvailableBehaviorsSuccess,
  fetchAvailableBehaviorsFailure,
} from "../actions/entityForm"

import api from "../../api"

function* fetch(_action) {
  try {
    const response = yield call(api.behaviors.index)
    yield put(fetchAvailableBehaviorsSuccess(response.data))
  } catch (e) {
    yield put(fetchAvailableBehaviorsFailure(e.response.data))
  }
}

export default function* onFetchRecords() {
  yield takeLatest(FETCH_AVAILABLE_BEHAVIORS, fetch)
}
