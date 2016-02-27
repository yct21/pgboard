import update from "react-addons-update"
import camelize from "camelize"

export function updateBoard(state, action) {
  let updatedState
  const updatedBoardStr = camelize(action.payload.board)
  const updatedBoard = JSON.parse(updatedBoardStr)

  if (state.isMaster) {
    updatedState = update(state, {
      remoteState: {
        board: {$set: updatedBoard}
      },

      consoleState: {
        $set: {
          editingState: updatedBoardStr,
          editingStateValid: true,
          previewingState: updatedBoard,
          currentLog: "meow"
        }
      }
    })
  } else {
    updatedState = update(state, {remoteState: {board: {$set: updatedBoard}}})
  }

  return updatedState
}
