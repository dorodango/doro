// Redux store

import { createStore, applyMiddleware, compose } from "redux"
import createSagaMiddleware from "redux-saga"

import reducers from "../reducers"
import sagas from "../sagas"
import mapObjIndexed from "ramda"

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose

const configureApp = initialState => {
  // Add middlewares here (sagas maybe?)
  const sagaMiddleware = createSagaMiddleware()
  const middlewares = [sagaMiddleware]

  // To get redux events logged in the browser... uncomment below
  // const { createLogger } = require("redux-logger");
  // middlewares.push(createLogger());

  const store = createStore(
    reducers,
    initialState,
    composeEnhancers(applyMiddleware(...middlewares))
  )
  sagas.forEach(saga => sagaMiddleware.run(saga))

  return store
}

export default configureApp
