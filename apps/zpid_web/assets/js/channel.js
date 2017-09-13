import { Socket } from 'phoenix'

const token = window.token
const userId = window.userId

const socket = new Socket('/socket', {params: {token}})
socket.connect()
const channel = socket.channel(`user:${userId}`, {})

export default channel
