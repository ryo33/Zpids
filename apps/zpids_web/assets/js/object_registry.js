import ZpidsObject from './zpids_object.js'

class ObjectRegistry {
  constructor(container) {
    this.container = container
    this.objects = {}
  }

  add(id, sprites, state, parentId) {
    const zpidsObject = new ZpidsObject(sprites, state)
    this.objects[id] = zpidsObject
    if (parentId) {
      const parent = this.objects[parentId].parent
      if (parent) {
        parent.addChild(zpidsObject.container)
      } else {
        console.error(`there is no parent ${parentId}`)
      }
    } else {
      this.container.addChild(zpidsObject.container)
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
