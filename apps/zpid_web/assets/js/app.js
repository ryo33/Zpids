import channel from './channel.js'
import Zpid from './zpid.js'
import ZpidObject from './zpid_object.js'

const start = (width, height) => {
  document.body.style.margin = '0px'
  const zpid = new Zpid({
    parentElement: document.body,
    frameWidth: window.innerWidth,
    frameHeight: window.innerHeight,
    virtualWidth: width,
    virtualHeight: height
  })
  window.onresize = () => zpid.resize(window.innerWidth, window.innerHeight)
  // background
  const graphics = new PIXI.Graphics()
  graphics.beginFill(0xFFFFFF)
  graphics.drawRect(0, 0, width, height)
  zpid.app.stage.addChildAt(graphics, 0)
  // handlers
  channel.on('add_object', ({ id, definition, state, parent_id: parentId }) => {
    console.log(id, definition, state, parentId)
    zpid.registry.add(id, definition, state, parentId)
  })
  channel.on('update_object', ({ id, state }) => {
    console.log(state)
    zpid.registry.update(id, state)
  })
  // TODO on delete_object
  // channel.on('delete_object', ({ id }) => {
  // })
  ;['w', 'a', 's', 'd', 'shift'].forEach(key => {
    zpid.keyHandler.on(key, 'down', () =>
      channel.push('keyboard_press', {key}))
    zpid.keyHandler.on(key, 'up', () =>
      channel.push('keyboard_release', {key}))
  })
  // pointer
  zpid.pointer.lock()
  zpid.mouseHandler.onMove((x, y) => {
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
