import React from "react"
import Header from "components/Header"

export default function GameIndex({localState, remoteState, dispatch}) {
  // const {gameListState, newGameModalState} = localState
  // const {gameInfo, board, playersInfo} = remoteState

  const headerProps = {dispatch}
  // const gameListProps = {gameListState, userInfo, games, dispatch}
  // const newGameModalProps = {newGameModalState, gameSetting, dispatch}

  return (
    <div>
      <Header {...headerProps}/>
    </div>
  )
}
