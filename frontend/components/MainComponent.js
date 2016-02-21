import React from "react"
import {connect} from "react-redux"
import Header from "components/Header"
import MasterConsole from "components/MasterConsole"
import PlayerBoard from "components/PlayerBoard"

export default function RawMainComponent({isMaster, consoleState, remoteState, dispatch}) {
  let masterConsoleBoard = null
  let viewBoard = null
  if (isMaster) {
    viewBoard = consoleState.previewingState

    const masterConsoleProps = {consoleState, dispatch}
    masterConsoleBoard = <MasterConsole {...masterConsoleProps} />
  } else {
    viewBoard = remoteState.board
  }

  const headerProps = {}
  const playerBoardProps = {players: viewBoard.players}
  // const gameListProps = {gameListState, userInfo, games, dispatch}
  // const newGameModalProps = {newGameModalState, gameSetting, dispatch}

  return (
    <div>
      <Header {...headerProps} />
      {masterConsoleBoard}
    </div>
  )
}

// transform and exports
const MainComponent = connect((state) => (state))(RawMainComponent)
export default MainComponent
