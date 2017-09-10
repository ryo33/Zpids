import { Socket } from 'phoenix'

class Channel {
  constructor() {
    const token = window.token
    const userId = window.userId

    const socket = new Socket('/socket', {params: {token}})
    socket.connect()
    const channel = socket.channel(`user:${userId}`, {})
    channel.join()
      .receive('ok', resp => {
        console.log('Joined successfully', resp)
      })
      .receive('error', resp => {
        alert('Failed to join a channel')
      })
  }

  onUpdateObject(handler) {
    channel.on('update_object', handler)
  }
}

export default Channel
