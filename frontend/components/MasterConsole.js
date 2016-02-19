import React from "react"
import Paper from "material-ui/lib/paper"
import TextField from "material-ui/lib/text-field"
import Avatar from "material-ui/lib/avatar"
import Divider from "material-ui/lib/divider"
import RaisedButton from "material-ui/lib/raised-button"
// import FactoryIcon from "icons/FactoryIcon"
import PaperHead from "components/PaperHead"
import {baseColors} from "styles"
import _ from "lodash"

// styles
const wrapStyle = {
  margin: "0 10%",
  paddingBottom: "1px"
}

const headerStyle = {
  buttonStyle: {
    backgroundColor: baseColors.selectedButtonColor
  }
}

const consoleStyle = {
  wrapDivStyle: {
    margin: "20px 2%"
  },

  fieldStyle: {
    backgroundColor: baseColors.fieldBackgroundColor
  }
}

const panelStyle = {
  wrapDivStyle: {
    margin: "10px 2%"
  },

  logFieldStyle: {
    display: "inline-block",
    width: "70%"
  },

  buttonStyle: {
    marginRight: "10px",
    float: "right"
  }
}

// renderers
export default function MasterConsole({boardState, dispatch}) {
  const paperHeadProps = {
    title: "Console"
  }

  const boardStateFieldProps = {
    style: consoleStyle.fieldStyle,
    value: boardState,
    multiLine: true,
    fullWidth: true,
    rows: 20
  }

  return (
    <Paper rounded={false} style={wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      <div style={consoleStyle.wrapDivStyle}>
        <TextField {...boardStateFieldProps}/>
      </div>
      <Divider />
      {panel(dispatch, "meow")}
    </Paper>
  )
}

function panel(dispatch, currentLog) {
  const logProps = {
    hintText: "so what have you done?",
    style: panelStyle.logFieldStyle,
    // value: currentLog
  }

  const submitButtonProps = {
    label: "OK",
    primary: true,
    style: panelStyle.buttonStyle,
    backgroundColor: baseColors.darkPrimaryColor
  }

  const resetButtonProps = {
    label: "reset",
    style: panelStyle.buttonStyle
  }

  return (
    <div style={panelStyle.wrapDivStyle}>
      <TextField {...logProps}/>
      <RaisedButton {...submitButtonProps} />
      <RaisedButton {...resetButtonProps} />
    </div>
  )
}
