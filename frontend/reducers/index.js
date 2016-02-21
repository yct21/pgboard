import {
  updateCurrentLog,
  updateEditingState,
  previewValidEditingState,
  previewInvalidEditingState,
  cancelStateEditing
} from "reducers/consoleReducers"

const reducers = {
  updateCurrentLog,
  updateEditingState,
  previewValidEditingState,
  previewInvalidEditingState,
  cancelStateEditing
}

export default function reduce(state, action) {
  if (reducers.hasOwnProperty(action.type)) {
    // so action and reducer has the very same name...
    return reducers[action.type](state, action)
  } else {
    return state
  }
}
