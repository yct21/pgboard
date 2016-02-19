import React from "react"
import {connect} from "react-redux"
import Header from "components/Header"
import MasterConsole from "components/MasterConsole"

export default function RawMainComponent({localState, remoteState, dispatch}) {
  const {gameMaster, boardState} = localState
  // const {gameInfo, board, playersInfo} = remoteState

  const headerProps = {dispatch}
  const masterConsoleProps = {dispatch}
  // const gameListProps = {gameListState, userInfo, games, dispatch}
  // const newGameModalProps = {newGameModalState, gameSetting, dispatch}

  return (
    <div>
      <Header {...headerProps}/>
      <MasterConsole/>
    </div>
  )
}

// transform and exports
const MainComponent = connect((state) => (state))(RawMainComponent)
export default MainComponent
