import React from "react"
import ReactDom from "react-dom"
import { createStore, applyMiddleware } from "redux"
import createLogger from "redux-logger"
import { Provider } from "react-redux"
import reducers from "reducers"
import MainComponent from "components/MainComponent"
import camelize from "camelize"
import {Socket} from "websocket/phoenix"

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
  const remoteState = {board: JSON.parse(camelize(window.__INITIAL_DATA__))}
  const isMaster = document.location.hash === "#meow"
  const channel = initializeChannel()
  const consoleState =
    isMaster ?
    initialMasterLocalState(remoteState.board) :
    null

  console.log(remoteState)

  return {remoteState, consoleState, channel, isMaster}
}

function initialMasterLocalState(board) {
  return {
    editingState: JSON.stringify(board),
    editingStateValid: true,
    previewingState: board,
    currentLog: "Meow"
  }
}

function initializeChannel() {
  const socketUrl = window.__CHANNEL_PATH__

  const socket = new Socket(socketUrl, {
    params: {},
    logger: (kind, msg, data) => {console.log(`${kind}: ${msg}`), data}
  })

  socket.connect()
  const channel = socket.channel("game")

  channel
    .join()
    .receive("ok", resp => console.log("websocket joined", resp))
    .receive("error", reason => console.log("joining websocket failed", reason))

  channel.on("updateBoard", ({board}) => {store.dispatch({type: "updateBoard", payload: {board}})})
  window.__channel__ = channel

  return channel
}
