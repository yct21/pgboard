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
export default function MasterConsole({consoleState, dispatch, channel}) {
  const {editingState, editingStateValid, currentLog} = consoleState

  const paperHeadProps = {
    title: "Console"
  }

  const boardStateFieldProps = {
    style: consoleStyle.fieldStyle,
    value: editingState,
    multiLine: true,
    fullWidth: true,
    rows: 20,
    onChange: onEditingStateChange(dispatch)
  }

  return (
    <Paper rounded={false} style={wrapStyle}>
      <PaperHead {...paperHeadProps}/>
      <div style={consoleStyle.wrapDivStyle}>
        <TextField {...boardStateFieldProps}/>
      </div>
      <Divider />
      {panel(dispatch, channel, currentLog, editingState, editingStateValid)}
    </Paper>
  )
}

function panel(dispatch, channel, currentLog, editingState, editingStateValid) {
  const logProps = {
    hintText: "so what have you done?",
    style: panelStyle.logFieldStyle,
    value: currentLog,
    errorText: editingStateValid ? null : "Board State not a valid JSON",
    onChange: onCurrentLogChange(dispatch)
  }

  const submitButtonProps = {
    label: "OK",
    primary: true,
    style: panelStyle.buttonStyle,
    backgroundColor: baseColors.darkPrimaryColor,
    onClick: onClickSubmit(editingState, channel, dispatch)
  }

  const previewButtonProps = {
    label: "Preview",
    primary: true,
    style: panelStyle.buttonStyle,
    backgroundColor: baseColors.darkPrimaryColor,
    onClick: onClickPreview(editingState, dispatch)
  }

  const resetButtonProps = {
    label: "Reset",
    style: panelStyle.buttonStyle,
    onClick: onClickReset(editingState, dispatch)
  }

  return (
    <div style={panelStyle.wrapDivStyle}>
      <TextField {...logProps}/>
      <RaisedButton {...submitButtonProps} />
      <RaisedButton {...previewButtonProps} />
      <RaisedButton {...resetButtonProps} />
    </div>
  )
}

// event handlers

function onCurrentLogChange(dispatch) {
  return (event) => {
    dispatch({type: "updateCurrentLog", payload: {currentLog: event.target.value}})
  }
}

function onEditingStateChange(dispatch) {
  return (event) => {
    dispatch({type: "updateEditingState", payload: {editingState: event.target.value}})
  }
}

function onClickReset(dispatch) {
  return () => {
    dispatch({type: "resetEditingState"})
  }
}

function onClickPreview(editingState, dispatch) {
  return () => {
    try {
      const previewState = JSON.parse(editingState)

      // if nothing happens
      dispatch({type: "previewValidEditingState", payload: {previewState}})
    } catch (e) {
      console.log(e)
      dispatch({type: "previewInvalidEditingState"})
    }
  }
}

function onClickSubmit(editingState, channel, dispatch) {
  return () => {
    try {
      const previewState = JSON.parse(editingState)
      previewState

      // if nothing happens
      channel
        .push("update_state", {"updated_board": editingState})
        .receive("error", e => console.log(e))
    } catch (e) {
      console.log(e)
      dispatch({type: "previewInvalidEditingState"})
    }
  }
}
