import React from "react"
import Header from "components/Header"

export default function GameIndex({localState, remoteState, dispatch}) {
  const {headerState, gameListState, newGameModalState} = localState
  const {gameInfo, board, playersInfo} = remoteState

  const headerProps = {headerState, dispatch}
  // const gameListProps = {gameListState, userInfo, games, dispatch}
  // const newGameModalProps = {newGameModalState, gameSetting, dispatch}

  return (
    <div>
      <Header {...headerProps}/>
    </div>
  )
}
