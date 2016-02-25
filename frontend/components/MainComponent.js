import React from "react"
import {connect} from "react-redux"
import Header from "components/Header"
import MasterConsole from "components/MasterConsole"
import PlayerBoard from "components/PlayerBoard"
import PlantBoard from "components/PlantBoard"

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
  const playerBoardProps = {players: viewBoard.players, playerOrder: viewBoard.playerOrder}
  const plantBoardProps = {plantsInMarket: viewBoard.plantsInMarket, gameStep: viewBoard.gameInfo.gameStep}

  return (
    <div>
      <Header {...headerProps} />
      {masterConsoleBoard}
      <PlayerBoard {...playerBoardProps} />
      <PlantBoard {...plantBoardProps} />
    </div>
  )
}

// transform and exports
const MainComponent = connect((state) => (state))(RawMainComponent)
export default MainComponent
