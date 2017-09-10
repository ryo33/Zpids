import lock from 'pointer-lock'
import fullscreen from 'fullscreen'

class PointerLock {
  constructor(element, onMove) {
    if (!lock.available()) {
      return alert('Please play on a browser which supports *Pointer Lock API*.')
      throw 'pointer lock not available'
    }
    const pointer = lock(element)
    pointer.on('attain', (movements) => {
      movements.on('data', function(move) {
        onMove(move.dx, move.dy)
      })
      this.locked = true
    })
    pointer.on('release', () => {
      this.locked = false
    })
    pointer.on('needs-fullscreen', () => {
      const fs = fullscreen(element)
      fs.once('attain', () => {
        pointer.request()
      })
      fs.request()
    })
    this.pointer = pointer
  }

  lock() {
    this.pointer.request()
  }

  unlock() {
    this.pointer.release()
  }
}

export default PointerLock
