import React from "react"
import ReactDom from "react-dom"
import { createStore, applyMiddleware } from "redux"
import createLogger from "redux-logger"
import { Provider } from "react-redux"
import reducers from "reducers"
import MainComponent from "components/MainComponent"
// import camelize from "camelize"

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
  const remoteState = {board: mockRemoteState()}
  const isMaster = document.location.hash === "#meow"
  const consoleState =
    isMaster ?
    initialMasterLocalState(remoteState.board) :
    null

  return {remoteState, consoleState, isMaster}
}

function initialMasterLocalState(board) {
  return {
    editingState: JSON.stringify(board),
    editingStateValid: true,
    previewingState: board,
    currentLog: "Meow"
  }
}

function mockRemoteState() {
  return {
    "playerOrder": [42, 11, 25, 21, 81],
    "tableOrder": [42],
    "gameInfo": {
      gameStep: 1,
      map: "usa"
    },
    "plantsInMarket": ["03", "04", "05", "06", "07", "08", "09", "10"],
    "players": {
      "42": {
        "id": 42,
        "name": "胭脂糖6",
        "color": "cyan",
        "portrait": "f7e3e883ade88482e7b39636e829",
        "funds": 42,
        "cities": 11,
        "plants": [11, 42, "step3"],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      },
      "11": {
        "id": 11,
        "name": "胭脂糖6",
        "color": "blue",
        "portrait": "f7e3e883ade88482e7b39636e829",
        "funds": 42,
        "cities": 11,
        "plants": [11, 50],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      },
      "25": {
        "id": 25,
        "name": "胭脂糖6",
        "color": "yellow",
        "portrait": "f7e3e883ade88482e7b39636e829",
        "funds": 42,
        "cities": 11,
        "plants": [11, 42],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      },
      "21": {
        "id": 21,
        "name": "胭脂糖6",
        "color": "orange",
        "portrait": "f7e3e883ade88482e7b39636e829",
        "funds": 42,
        "cities": 11,
        "plants": [11, 42],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      },
      "81": {
        "id": 81,
        "name": "胭脂糖6",
        "color": "purple",
        "portrait": "f7e3e883ade88482e7b39636e829",
        "funds": 42,
        "cities": 11,
        "plants": [11, 42],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      }
    }
  }
}
