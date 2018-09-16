import { combineReducers } from "redux"

import app from "./app.js"
import entityForm from "../GameStateEditor/reducers/entityForm"
import flashMessage from "../shared/reducers/flashMessage"
import gameStateEditor from "../GameStateEditor/reducers/gameStateEditor"
import tabs from "../shared/reducers/tabs"
import userSession from "../shared/reducers/userSession"

export default combineReducers({
  app,
  entityForm,
  flashMessage,
  gameStateEditor,
  tabs,
  userSession
})
