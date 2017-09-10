import ObjectRegistry from './object_registry.js'
import PointerLock from './pointer_lock.js'
import KeyHandler from './key_handler.js'
import MouseHandler from './mouse_handler.js'
import Channel from './channel.js'
import { WIDTH, HEIGHT } from './constants.js'

class Zpid {
  constructor() {
    // app
    this.app = new PIXI.Application({
      antialias: false,
      transparent: false,
      resolution: 1,
      width: window.innerWidth,
      height: window.innerHeight
    })
    this.app.view.style.position = 'absolute'
    this.app.view.style.top = '0px'
    this.app.view.style.left = '0px'
    document.body.appendChild(this.app.view)
    window.addEventListener('contextmenu', e => {
      e.preventDefault()
    })
    // resize
    window.onresize = () => this.onResize()
    this.onResize()
    // event handler
    this.keyHandler = new KeyHandler()
    this.mouseHandler = new MouseHandler()
    // pointer
    this.pointer = new PointerLock(this.app.view,
      (x, y) => this.mouseHandler.handleMove(x, y))
    // containers
    const gameContainer = new PIXI.Container()
    const uiContainer = new PIXI.Container()
    const gameObjects = new ObjectRegistry(gameContainer)
    const uiObjects = new ObjectRegistry(uiContainer)
    this.game = {
      container: gameContainer,
      objects: gameObjects
    }
    this.ui = {
      container: uiContainer,
      objects: uiObjects
    }
    this.app.stage.addChild(gameContainer)
    this.app.stage.addChild(uiContainer)
    // channel
    this.channel = new Channel()
  }

  onResize() {
    const actualWidth = window.innerWidth
    const actualHeight = window.innerHeight
    const widthRatio = actualWidth / WIDTH
    const heightRatio = actualHeight / HEIGHT
    const ratio = Math.min(widthRatio, heightRatio)
    const transformX = (actualWidth - WIDTH*ratio) / 2
    const transformY = (actualHeight - HEIGHT*ratio) / 2
    this.app.stage.setTransform(transformX, transformY, ratio, ratio)
    this.app.renderer.resize(actualWidth, actualHeight)
  }
}

export default Zpid
