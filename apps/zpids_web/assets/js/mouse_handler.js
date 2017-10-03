class MouseHandler {
  constructor(element) {
    element.addEventListener('mousedown',
      (e) => this.handleDown(e))
    element.addEventListener('mouseup',
      (e) => this.handleUp(e))
    element.addEventListener('wheel',
      (e) => this.handleWheel(e))
    this.handlers = {}
    this.moveHandler = null
    this.wheelHandler = null
  }
  on(operation, upOrDown, handler) {
    this.handlers[`${operation}.${upOrDown}`] = handler
  }
  onMove(handler) {
    this.moveHandler = handler
  }
  onWheel(handler) {
    this.wheelHandler = handler
  }
  handle(e, upOrDown) {
    let operation = null
    if (e.button == 0) operation = 'left'
    else if (e.button == 2) operation = 'right'
    else return
    const handler = this.handlers[`${operation}.${upOrDown}`]
    if (!handler) return
    handler()
  }
  handleDown(e) {
    this.handle(e, 'down')
  }
  handleUp(e) {
    this.handle(e, 'up')
  }
  handleWheel(e) {
    if (this.wheelHandler) {
      this.wheelHandler(e.deltaY)
    }
  }
  handleMove(x, y) {
    if (this.moveHandler) {
      this.moveHandler(x, y)
    }
  }
}

export default MouseHandler
