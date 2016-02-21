import React from "react"
import Paper from "material-ui/lib/paper"
import TextField from "material-ui/lib/text-field"
import Divider from "material-ui/lib/divider"
import RaisedButton from "material-ui/lib/raised-button"
// import FactoryIcon from "icons/FactoryIcon"
import PaperHead from "components/PaperHead"
import {baseColors} from "styles"

// styles
const wrapStyle = {
  margin: "0 10%",
  paddingBottom: "1px"
}

const playerListsStyle = {
  wrapDivStyle: {
    margin: "20px 2%"
  }
}

export default function PlayerBoard({players}) {
  const paperHeadProps = {
    title: "Players"
  }

  return (
    <Paper rounded={false} style={wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      <div style={playerListsStyle.wrapDivStyle}>
      </div>
    </Paper>
  )
}
