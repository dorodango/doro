import "regenerator-runtime/runtime"
import { takeLatest, put, call, spawn } from "redux-saga/effects"
import download from "downloadjs"

import {
  DOWNLOAD_ENTITIES
} from "../actions/gameStateEditor"

import api from "../../api"

const _downloadEntities = (entities, filename) => {
  return () => download(
    JSON.stringify({entities: entities}),
    filename,
    "application/json"
  )
};

function* downloadEntities(action) {
  try {
    const entities = action.data.entities
    const filename = action.data.filename || "entities.json"
    yield call(_downloadEntities(entities, filename))
  } catch (e) {
  }
}

export default function* onDownloadEntities() {
  yield takeLatest(DOWNLOAD_ENTITIES, downloadEntities)
}
