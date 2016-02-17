// import updateRemoteState from "reducers/updateRemoteState"
// import * as newGameModalReducers from "reducers/newGameModalReducers"
// import * as headerPlayerInfoReducers from "reducers/headerPlayerInfoReducers"
// import * as initializeAppReducers from "reducers/initializeAppReducers"

const reducers = {
  // updateRemoteState,
  // ...initializeAppReducers,
  // ...headerPlayerInfoReducers,
  // ...newGameModalReducers
}

export default function reduce(state, action) {
  if (reducers.hasOwnProperty(action.type)) {
    // so action and reducer has the very same name...
    return reducers[action.type](state, action)
  } else {
    return state
  }
}
