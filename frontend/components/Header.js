import React from "react"
import AppBar from "material-ui/lib/app-bar"
import FlatButton from "material-ui/lib/flat-button"
// import actions from "actions"
import {baseColors} from "styles"

// styles
const titleStyle = {
  marginLeft: "2%"
}

const appbarStyle = {
  padding: "0 10%",
  backgroundColor: baseColors.darkPrimaryColor
}

const rightElementStyle = {
  paddingRight: "2%"
}

// renderers
export default function Header({}) {
  const iconElementRight = loginElement()

  const appBarProps = {
    style: appbarStyle,
    title: <span style={titleStyle}>{"POWER GRID"}</span>,
    showMenuIconButton: false,
    iconStyleRight: rightElementStyle,
    iconElementRight
  }

  return <AppBar {...appBarProps}/>
}

function loginElement() {
  return <FlatButton label="Log in"/>
}
