import React from "react"
import Paper from "material-ui/lib/paper"
import RaisedButton from "material-ui/lib/raised-button"
import List from "material-ui/lib/lists/list"
import ListItem from "material-ui/lib/lists/list-item"
import Avatar from "material-ui/lib/avatar"
// import FactoryIcon from "icons/FactoryIcon"
import PaperHead from "components/PaperHead"
import {baseColors} from "styles"
import _ from "lodash"

// styles
const wrapStyle = {
  margin: "0 10%",
  minHeight: "600px"
}

const headerStyle = {
  buttonStyle: {
    backgroundColor: baseColors.selectedButtonColor
  }
}

const contentStyle = {
  wrapDivStyle: {
    margin: "20px 2%"
  },

  wrapListStyle: {
    display: "inline-block",
    verticalAlign: "top",
    width: "25%",
    minHeight: window.innerHeight * 0.7,
    margin: "10px 10%"
  }
}

// renderers
export default function MasterConsole({boardState, dispatch}) {
  const paperHeadProps = {
    title: "Console"
  }

  return (
    <Paper rounded={false} style={wrapStyle}>
      <PaperHead {...paperHeadProps}/>
    </Paper>
  )
}
