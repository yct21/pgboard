import React from "react"
import ReactDom from "react-dom"
import { createStore, applyMiddleware } from "redux"
import createLogger from "redux-logger"
import { Provider } from "react-redux"
import reducers from "reducers"
import MainComponent from "components/MainComponent"
import camelize from "camelize"

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

function initialState() {
  const remoteState = camelize(window.__INITIAL_DATA__)
  const localState =
    document.location.hash == "#meow" ?
    {gameMaster: true, board: null}:
    {gameMaster: false}

  return {remoteState, localState}
}
