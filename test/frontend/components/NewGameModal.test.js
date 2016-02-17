import React from "react"
import {testSuit, shallow, createDispatcher, createChannel} from "../testHelper"
import NewGameModal, {initialize as initializeNewGameModal} from "components/NewGameModal"
import _ from "lodash"

const {tags, test} = testSuit("components/NewGameModal", setup)

function setup(tags) {
  const {
    modalOpen: modalOpen = true,
    hasPassword: hasPassword = false,
    password: password = null
  } = tags

  const gameSetting = {
    minPlayerAmount: 2,
    maxPlayerAmount: 42,
    defaultPlayerAmount: 21,
    availableMaps: ["Hangzhou", "Shanghai", "Beijing", "Tianjing"],
    defaultMap: "Shanghai"
  }

  const {dispatch, assertLastDispatchedAction} = createDispatcher()
  const {channel, expectChannelReply} = createChannel()

  let newGameModalState = initializeNewGameModal({gameSetting, dispatch, channel})
  newGameModalState.open = modalOpen
  newGameModalState.hasPassword = hasPassword
  newGameModalState.password = password

  const newGameModalProps = {newGameModalState, gameSetting}
  const component = shallow(<NewGameModal {...newGameModalProps}/>)

  return {component, assertLastDispatchedAction, expectChannelReply}
}

tags({modalOpen: false})
test("dialog when its state.open == false", (t, {component}) => {
  const dialogProps = component.find("Dialog").first().props()
  t.false(dialogProps.open, "the dialog should be open")
  t.equal(dialogProps.title, "New Game", "it has a title")
})

tags({})
test("dialog when its state.open == true", (t, {component}) => {
  const dialogProps = component.find("Dialog").first().props()
  t.true(dialogProps.open, "the dialog should be open")
  t.equal(dialogProps.title, "New Game", "it has a title")
})

tags({hasPassword: false})
test("password fields when state.hasPassword == false", (t, {component, assertLastDispatchedAction}) => {
  const checkbox = component.find("Checkbox").first()
  const checkboxProps = checkbox.props()
  t.false(checkboxProps.checked, "password checkbox is not checked")
  t.equal(checkboxProps.label, "Password", "it has a label")

  const passwordFieldProps = component.find("TextField").props()
  t.true(passwordFieldProps.disabled, "password field is disabled")

  checkbox.simulate("click")
  assertLastDispatchedAction(t, "toggleNewGameModalHasPassword", undefined)
})

tags({hasPassword: true, password: "meow"})
test("password fields when state.hasPassword == true", (t, {component, assertLastDispatchedAction}) => {
  const wrapDiv = component.find("Dialog").first().children("div").at(0)

  const checkbox = wrapDiv.find("Checkbox").first()
  const checkboxProps = checkbox.props()
  t.true(checkboxProps.checked, "password checkbox is checked")
  t.equal(checkboxProps.label, "Password", "it has a label")

  const passwordField = wrapDiv.find("TextField").first()
  const passwordFieldProps = passwordField.props()
  t.false(passwordFieldProps.disabled, "password field is not disalbed")
  t.equal(passwordFieldProps.value, "meow", "password field has a value")
  checkbox.simulate("click")
  assertLastDispatchedAction(t, "toggleNewGameModalHasPassword", undefined)

  const event = {target: {value: "moəw"}}
  passwordField.simulate("change", event)
  assertLastDispatchedAction(t, "updateNewGameModalPassword", {password: "moəw"})
})

tags({})
test("player amount selection fields", (t, {component, assertLastDispatchedAction}) => {
  const wrapDiv = component.find("Dialog").first().children("div").at(1)

  const buttons = wrapDiv.find("RaisedButton")
  t.equal(buttons.length, 41, "its has buttons for minPlayerAmount to maxPlayerAmount")

  const curSelectedButton = buttons.at(20)
  t.equal(curSelectedButton.props().key, 21, "its react key is player amount")
  t.equal(curSelectedButton.props().label, 21, "its label is also player amount")

  t.equal(curSelectedButton.props().)
})
