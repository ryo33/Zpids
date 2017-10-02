import keycode from 'keycode'

class KeyHandler {
  constructor(element) {
    element.addEventListener('keydown',
      (e) => this.handleKeyDown(e))
    element.addEventListener('keyup',
      (e) => this.handleKeyUp(e))
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
    const handler = this.handlers[`${keycode(e)}.${upOrDown}`]
    if (handler) handler()
  }
}

export default KeyHandler
