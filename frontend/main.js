import React from "react"
import ReactDom from "react-dom"
import { createStore, applyMiddleware } from "redux"
import createLogger from "redux-logger"
import { Provider } from "react-redux"
import reducers from "reducers"
import MainComponent from "components/MainComponent"

// so we have a store here
let logger = createLogger()
let createStoreWithMiddleware = applyMiddleware(logger)(createStore)
let store = createStoreWithMiddleware(reducers, initialState())

let rootElement = document.getElementById("root")
ReactDom.render(
  <Provider store={store}>
    <MainComponent />
  </Provider>,
  rootElement
)
