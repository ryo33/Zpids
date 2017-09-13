import Zpid from './zpid.js'
import {
  WIDTH, HEIGHT, POINTER_POSITION
} from './constants.js'

const zpid = new Zpid()
// background
const graphics = new PIXI.Graphics()
graphics.beginFill(0xFFFFFF)
graphics.drawRect(0, 0, WIDTH, HEIGHT)
zpid.app.stage.addChildAt(graphics, 0)
// player
const frames = new Array(8)
for (let i = 0; i < frames.length; i ++) {
  frames[i] = new PIXI.Rectangle(i * 32, 0, 32, 42)
}
const object = {
  sprites: {
    walk: {
      imageUrl: 'images/temporary/officer_walk_strip.png',
      frames: frames,
    }
  },
  state: {
    walk: {
      x: WIDTH / 2,
      y: HEIGHT / 2,
      width: 64,
      height: 90,
      anchor: {x: 0.5, y: 0.5},
      rotation: 0,
      animationSpeed: 0.1,
      play: true
    }
  }
}
//zpid.game.objects.add(zpid.playerId, object)
// handlers
zpid.channel.on('update_object', ({ id, object }) => {
  // TODO Display
})
zpid.keyHandler.on('dash', 'down', () => {
  const nextState = {
    walk: {
      animationSpeed: 0.2
    }
  }
  zpid.game.objects.update(zpid.playerId, nextState)
})
zpid.keyHandler.on('dash', 'up', () => {
  const nextState = {
    walk: {
      animationSpeed: 0.1
    }
  }
  zpid.game.objects.update(zpid.playerId, nextState)
})
const CURSOR_SENSITIVITY = 0.005
// pointer
const pointer = PIXI.Sprite.fromImage('/images/pointer.png')
pointer.anchor.x = POINTER_POSITION.x
pointer.anchor.y = POINTER_POSITION.y
pointer.visible = false
zpid.app.stage.addChild(pointer)
zpid.keyHandler.on('pointer', 'down', () => {
  pointer.visible = true
  pointer.x = WIDTH / 2
  pointer.y = HEIGHT / 2
})
zpid.keyHandler.on('pointer', 'up', () => {
  pointer.visible = false
})
zpid.mouseHandler.onMove((x, y) => {
  pointer.x += x
  pointer.y += y
  const deltaRadian = x * CURSOR_SENSITIVITY
  const sprite = zpid.game.objects.get(zpid.playerId).sprites.walk
  const nextState = {
    walk: {
      rotation: sprite.rotation + deltaRadian
    }
  }
  //zpid.game.objects.update(zpid.playerId, nextState)
})
