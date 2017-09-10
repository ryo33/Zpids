import ZpidObject from './zpid_object.js'

class ObjectRegistry {
  constructor(container) {
    this.container = container
    this.objects = {}
  }

  add(id, object) {
    const zpidObject = new ZpidObject(object)
    this.objects[id] = zpidObject
    this.container.addChild(zpidObject.container)
  }

  update(id, state) {
    this.objects[id].applyState(state)
  }

  get(id) {
    return this.objects[id]
  }
}

export default ObjectRegistry
