import update from "react-addons-update"

export function updateCurrentLog(state, action) {
  return update(state, {consoleState: {currentLog: {$set: action.payload.currentLog}}})
}

export function updateEditingState(state, action) {
  return update(state, {consoleState: {editingState: {$set: action.payload.editingState}}})
}

export function previewValidEditingState(state, action) {
  return update(
    state,
    {
      consoleState: {
        previewingState: {$set: action.payload.previewState},
        editingStateValid: {$set: true}
      }
    }
  )
}

export function previewInvalidEditingState(state) {
  return update(state, {consoleState: {editingStateValid: {$set: false}}})
}

export function cancelStateEditing(state) {
  const originState = state.remoteState.board
  return update(
    state,
    {
      consoleState: {
        editingState: {$set: JSON.stringify(originState)},
        editingStateValid: {$set: true},
        previewingState: {$set: originState}}
    }
  )
}
