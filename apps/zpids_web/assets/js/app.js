import channel from './channel.js'
import Zpids from './zpids.js'
import ZpidsObject from './zpids_object.js'

const start = (width, height) => {
  document.body.style.margin = '0px'
  const zpids = new Zpids({
    parentElement: document.body,
    frameWidth: window.innerWidth,
    frameHeight: window.innerHeight,
    virtualWidth: width,
    virtualHeight: height
  })
  window.onresize = () => zpids.resize(window.innerWidth, window.innerHeight)
  // background
  const graphics = new PIXI.Graphics()
  graphics.beginFill(0xFFFFFF)
  graphics.drawRect(0, 0, width, height)
  zpids.app.stage.addChildAt(graphics, 0)
  // handlers
  channel.on('add_object', ({ id, definition, state, parent_id: parentId }) => {
    console.log(id, definition, state, parentId)
    zpids.registry.add(id, definition, state, parentId)
  })
  channel.on('update_object', ({ id, state }) => {
    console.log(state)
    zpids.registry.update(id, state)
  })
  // TODO on delete_object
  // channel.on('delete_object', ({ id }) => {
  // })
  ;['w', 'a', 's', 'd', 'shift'].forEach(key => {
    zpids.keyHandler.on(key, 'down', () =>
      channel.push('keyboard_press', {key}))
    zpids.keyHandler.on(key, 'up', () =>
      channel.push('keyboard_release', {key}))
  })
  // pointer
  zpids.pointer.lock()
  zpids.mouseHandler.onMove((x, y) => {
    channel.push('mouse_pointer', {x, y})
  })
}

channel.join()
  .receive('ok', ({ width, height }) => {
    start(width, height)
  })
  .receive('error', resp => {
    console.error('Failed to join a channel')
  })
