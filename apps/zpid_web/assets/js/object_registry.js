import ZpidObject from './zpid_object.js'

class ObjectRegistry {
  constructor(container) {
    this.container = container
    this.objects = {}
  }

  add(id, sprites, state, parentId) {
    const zpidObject = new ZpidObject(sprites, state)
    this.objects[id] = zpidObject
    if (parentId) {
      const parent = this.objects[parentId].parent
      console.log(parent)
      if (parent) {
        parent.addChild(zpidObject.container)
      } else {
        console.error(`there is no parent ${parentId}`)
      }
    } else {
      this.container.addChild(zpidObject.container)
    }
  }

  update(id, state) {
    this.objects[id].applyState(state)
  }

  get(id) {
    return this.objects[id]
  }
}

export default ObjectRegistry
