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
    "playerOrder": [42, 11, 25, 21, 81, 49],
    "resources": {
      "coal": 17,
      "oil": 22,
      "garbage": 14,
      "uranium": 3
    },
    "tableOrder": [42],
    "gameInfo": {
      "gameStep": 1,
      "map": "usa"
    },
    "plantsInMarket": ["03", "04", "05", "06", "07", "08", "09", "10"],
    "players": {
      "42": {
        "id": 42,
        "name": "Era_Darkstar",
        "color": "pink",
        "portrait": "a5cf4572615f4461726b73746172370c",
        "funds": 42,
        "cities": 11,
        "plants": [11, 42, 50],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      },
      "11": {
        "id": 11,
        "name": "Era_Darkstar",
        "color": "blue",
        "portrait": "a5cf4572615f4461726b73746172370c",
        "funds": 42,
        "cities": 11,
        "plants": [11, 50, "05"],
        "resources": {
          "coal": 1,
          "oil": 2,
          "garbage": 4,
          "uranium": 8
        }
      },
      "25": {
        "id": 25,
        "name": "Era_Darkstar",
        "color": "red",
        "portrait": "a5cf4572615f4461726b73746172370c",
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
        "name": "Era_Darkstar",
        "color": "orange",
        "portrait": "a5cf4572615f4461726b73746172370c",
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
        "name": "Era_Darkstar",
        "color": "purple",
        "portrait": "a5cf4572615f4461726b73746172370c",
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
      "49": {
        "id": 49,
        "name": "Era_Darkstar",
        "color": "black",
        "portrait": "a5cf4572615f4461726b73746172370c",
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
    },
    citiesOwner: {
      "seattle": "not_selected",
      "portland": "not_selected",
      "boise": "not_selected",
      "billings": "not_selected",
      "cheyenne": "not_selected",
      "omaha": "not_selected",
      "denver": "not_selected",
      "san_francisco": "not_selected",
      "los_angeles": "not_selected",
      "las_vegas": "not_selected",
      "san_diego": "not_selected",
      "phoenix": "not_selected",
      "santa_fe": "not_selected",
      "salt_lake_city": "not_selected",
      "fargo": "not_selected",
      "minneapolis": "not_selected",
      "chicago": "not_selected",
      "duluth": "not_selected",
      "cincinnati": "not_selected",
      "st_louis": "not_selected",
      "knoxville": "not_selected",
      "kansas_city": "not_selected",
      "oklahoma_city": "not_selected",
      "dallas": "not_selected",
      "houston": "not_selected",
      "new_orleans": "not_selected",
      "birmingham": "not_selected",
      "memphis": "not_selected",
      "detroit": "not_selected",
      "pittsburgh": "not_selected",
      "buffalo": "not_selected",
      "boston": "not_selected",
      "new_york": "not_selected",
      "philadelphia": "not_selected",
      "washington": "not_selected",
      "atlanta": "not_selected",
      "norfolk": "not_selected",
      "raleigh": "not_selected",
      "savannah": "not_selected",
      "jacksonville": "not_selected",
      "tampa": "not_selected",
      "miami": "not_selected"
    }
  }
}
