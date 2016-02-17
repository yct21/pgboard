import {test as rawTest} from "tape"
import {shallow} from "enzyme"

function testSuit(moduleName, setup = null, teardown = null) {
  let _testTags

  // wait, function decorator is even not a part of the ES7 draft?
  const tags = (testTags) => {
    _testTags = testTags
  }

  const test = (description, testBlock) => {
    const {
      async: async = false,
      plan: plannedTests = null
    } = _testTags

    let testParameters = {}

    if (setup) {
      testParameters = setup(_testTags)
    }

    rawTest(`${moduleName} - ${description}`, (tape) => {
      if (plannedTests) {
        tape.plan(plannedTests)
      }

      testBlock(tape, testParameters)

      if (!async) {
        tape.end()
      }
    })

    if (teardown) {
      teardown(_testTags)
    }
  }

  return {tags, test}
}

// hand made stub it is...
function createDispatcher() {
  let _dispatchedActions = []

  const dispatchedActions = () => {
    return _dispatchedActions
  }

  const dispatch = (action) => {
    _dispatchedActions.push(action)
  }

  const assertLastDispatchedAction = (tape, actionType, payload, message) => {
    if (message === undefined) {
      message = `should dispatch a ${actionType} action`
    }

    tape.deepEqual(
      _dispatchedActions[_dispatchedActions.length-1],
      {type: actionType, payload},
      message
    )
  }

  return {dispatchedActions, assertLastDispatchedAction, dispatch}
}

function createChannel() {
  let _pushedMessage = []
  let _expectedMessage = null
  let _expectedMessagePayload =null

  let _fakedReplyCreated = 0
  const maxFakedReplyAllowed = 1042 //wtf

  const expectChannelReply = (message, payload) => {
    _expectedMessage = message
    _expectedMessagePayload= payload
  }

  function createFakedReply() {
    // avoid infinate recursion
    _fakedReplyCreated = _fakedReplyCreated + 1

    if (_fakedReplyCreated > maxFakedReplyAllowed) {
      throw "help I'm trapped in a echo valley"
    } else {
      return {
        receive: (message, callback) => {
          if (message === _expectedMessage) {
            // yeah don't return anything
            callback(_expectedMessagePayload)
          } else {
            return createFakedReply()
          }
        }
      }
    }

  }

  const channel = {
    push: (message, payload) => {
      _pushedMessage.push({message, payload})

      return createFakedReply()
    }
  }

  return {channel, expectChannelReply}
}

export {testSuit, shallow, createDispatcher, createChannel}
