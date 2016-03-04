import React from "react"
import {connect} from "react-redux"
import Header from "components/Header"
import MasterConsole from "components/MasterConsole"
import PlayerBoard from "components/PlayerBoard"
import PlantBoard from "components/PlantBoard"
import ResourceBoard from "components/ResourceBoard"
import MapBoard from "components/MapBoard"
import gameMaps from "game/maps"

export default function RawMainComponent({isMaster, consoleState, remoteState, channel, dispatch}) {
  let masterConsoleBoard = null
  let viewBoard = null
  if (isMaster) {
    viewBoard = consoleState.previewingState

    const masterConsoleProps = {consoleState, dispatch, channel}
    masterConsoleBoard = <MasterConsole {...masterConsoleProps} />
  } else {
    viewBoard = remoteState.board
  }

  const headerProps = {}
  const playerBoardProps = {players: viewBoard.players, playerOrder: viewBoard.playerOrder}
  const plantBoardProps = {plantsInMarket: viewBoard.plantsInMarket, gameStep: viewBoard.gameInfo.gameStep}
  const resourceBoardProps = {resources: viewBoard.resources}
  const mapBoardProps = {players: viewBoard.players, citiesOwner: viewBoard.citiesOwner, gameMap: gameMaps[viewBoard.gameInfo.map]}

  return (
    <div>
      <Header {...headerProps} />
      {masterConsoleBoard}
      <PlayerBoard {...playerBoardProps} />
      <PlantBoard {...plantBoardProps} />
      <ResourceBoard {...resourceBoardProps} />
      <MapBoard {...mapBoardProps} />
    </div>
  )
}

// transform and exports
const MainComponent = connect((state) => (state))(RawMainComponent)
export default MainComponent
