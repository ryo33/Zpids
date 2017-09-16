import Zpid from './zpid.js'
import ZpidObject from './zpid_object.js'
import {
  WIDTH, HEIGHT, POINTER_POSITION
} from './constants.js'

const zpid = new Zpid()
// background
const graphics = new PIXI.Graphics()
graphics.beginFill(0xFFFFFF)
graphics.drawRect(0, 0, WIDTH, HEIGHT)
zpid.app.stage.addChildAt(graphics, 0)
// handlers
zpid.channel.on('add_object', ({ id, sprites, state }) => {
  zpid.game.objects.add(id, sprites, state)
})
zpid.channel.on('update_object', ({ id, state }) => {
  console.log('update', state)
  zpid.game.objects.update(id, state)
})
// TODO on delete_object
const movement_keys = {w: false, s: false, a: false, d: false}
const update_movement = (key, state) => {
  movement_keys[key] = state
  const movement = {x: 0, y: 0}
  if (movement_keys.w) movement.y -= 1
  if (movement_keys.s) movement.y += 1
  if (movement_keys.a) movement.x -= 1
  if (movement_keys.d) movement.x += 1
  zpid.channel.push('movement', movement)
}
zpid.keyHandler.on('w', 'down', () => update_movement('w', true))
zpid.keyHandler.on('w', 'up', () => update_movement('w', false))
zpid.keyHandler.on('s', 'down', () => update_movement('s', true))
zpid.keyHandler.on('s', 'up', () => update_movement('s', false))
zpid.keyHandler.on('a', 'down', () => update_movement('a', true))
zpid.keyHandler.on('a', 'up', () => update_movement('a', false))
zpid.keyHandler.on('d', 'down', () => update_movement('d', true))
zpid.keyHandler.on('d', 'up', () => update_movement('d', false))
zpid.keyHandler.on('dash', 'down', () => {
  zpid.channel.push('start_dash', {})
})
zpid.keyHandler.on('dash', 'up', () => {
  zpid.channel.push('end_dash', {})
})
const CURSOR_SENSITIVITY = 0.005
// scale
const width_meter = 10
const scale = WIDTH / width_meter
zpid.game.container.setTransform(0, 0, scale, scale)
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
  if (pointer.visible) {
    pointer.x += x
    pointer.y += y
  } else {
    const deltaRadian = x * CURSOR_SENSITIVITY
    zpid.channel.push('rotation', {radian: deltaRadian})
  }
})
