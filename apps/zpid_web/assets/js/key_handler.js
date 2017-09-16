import keycode from 'keycode'
import objectPath from 'object-path'

const defaultKeymap = {
  w: 'w',
  s: 's',
  a: 'a',
  d: 'd',
  pointer: 'ctrl',
  dash: 'shift',
  step: 'space',
  voice: 'tab'
}

class KeyHandler {
  constructor(keymap = defaultKeymap) {
    document.addEventListener('keydown',
      (e) => this.handleKeyDown(e))
    document.addEventListener('keyup',
      (e) => this.handleKeyUp(e))
    this.keymap = {}
    Object.keys(keymap).forEach(operation => {
      this.keymap[keymap[operation]] = operation
    })
    this.handlers = {}
  }
  on(operation, upOrDown, handler) {
    this.handlers[`${operation}.${upOrDown}`] = handler
  }
  handleKeyDown(e) {
    e.preventDefault()
    this.handle(e, 'down')
  }
  handleKeyUp(e) {
    e.preventDefault()
    this.handle(e, 'up')
  }
  handle(e, upOrDown) {
    const operation = this.keymap[keycode(e)]
    if (!operation) return
    const handler = this.handlers[`${operation}.${upOrDown}`]
    if (!handler) return
    handler()
  }
}

export default KeyHandler
