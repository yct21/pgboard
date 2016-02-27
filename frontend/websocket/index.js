import {Socket} from "websocket/phoenix"

let socket = new Socket("/socket", {
  params: {token: window.userToken},
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) }
})

socket.connect()

export default socket
