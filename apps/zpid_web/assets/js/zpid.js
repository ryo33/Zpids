import ObjectRegistry from './object_registry.js'
import PointerLock from './pointer_lock.js'
import KeyHandler from './key_handler.js'
import MouseHandler from './mouse_handler.js'

class Zpid {
  constructor({
    element = document.body,
    viewStyle = {position: 'abusolute', top: '0px', left: '0px'},
    frameWidth = window.innerWidth,
    frameHeight = window.innerHeight,
    virtualWidth = 1600,
    virtualHeight = 900
  }) {
    this.element = element
    this.virtualWidth = virtualWidth
    this.virtualHeight = virtualHeight
    // app
    this.app = new PIXI.Application({
      antialias: false,
      transparent: false,
      resolution: 1,
      width: frameWidth,
      height: frameHeight
    })
    Object.keys(viewStyle).forEach(key => {
      this.app.view.style[key] = viewStyle[key]
    })
    element.appendChild(this.app.view)
    element.addEventListener('contextmenu', e => {
      e.preventDefault()
    })
    this.resize(frameWidth, frameHeight)
    // event handler
    this.keyHandler = new KeyHandler(element)
    this.mouseHandler = new MouseHandler(element)
    // pointer
    this.pointer = new PointerLock(this.app.view,
      (x, y) => this.mouseHandler.handleMove(x, y))
    // containers
    const container = new PIXI.Container()
    this.registry = new ObjectRegistry(container)
    this.app.stage.addChild(container)
  }

  resize(frameWidth, frameHeight) {
    const actualWidth = frameWidth
    const actualHeight = frameHeight
    const widthRatio = actualWidth / this.virtualWidth
    const heightRatio = actualHeight / this.virtualHeight
    const ratio = Math.min(widthRatio, heightRatio)
    const transformX = (actualWidth - this.virtualWidth*ratio) / 2
    const transformY = (actualHeight - this.virtualHeight*ratio) / 2
    this.app.stage.setTransform(transformX, transformY, ratio, ratio)
    this.app.renderer.resize(actualWidth, actualHeight)
  }
}

export default Zpid
