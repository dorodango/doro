import React from "react"
import ReactDOM from "react-dom"
import { Provider } from "react-redux"
import configureApp from "./store/configureApp"

import App from "./App"

const doro = document.getElementById("Doro")
if (doro) {
  const store = configureApp({
    /* initial state */
  })
  ReactDOM.render(
    <Provider store={store}>
      <App />
    </Provider>,
    doro
  )
}
