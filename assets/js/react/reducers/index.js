import { combineReducers } from "redux"
import app from "./app.js"
import entityForm from "../GameStateEditor/reducers/entityForm"
import gameStateEditor from "../GameStateEditor/reducers/gameStateEditor"
import flashMessage from "../shared/reducers/flashMessage"
import userSession from "../shared/reducers/userSession"

export default combineReducers({
  app,
  entityForm,
  gameStateEditor,
  flashMessage,
  userSession
})
