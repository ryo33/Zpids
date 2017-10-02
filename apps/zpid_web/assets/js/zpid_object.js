const DIRECTRY_UPDATE_KEYS = [
  'x', 'y', 'rotation', 'visible', 'alpha']

class ZpidObject {
  constructor(definitions, state) {
    this.objects = {}
    this.parent = null
    this.container = new PIXI.Container()
    Object.keys(definitions).forEach(name => {
      this.container.addChild(this.createObject(name, definitions[name]))
    })
    this.applyState(state)
  }

  createObject(name, params) {
    const {
      children,
      container,
      sprite,
      animated_sprite: animatedSprite,
      parent
    } = params
    let object
    if (container) {
      object = new PIXI.Container()
    } else if (sprite) {
      const { image_url: imageUrl, frame } = sprite
      if (frame) {
        const [texture] = this.createTextures(imageUrl, [frame])
        object = new PIXI.Sprite(texture)
      } else {
        const texture = PIXI.Texture.fromImage(imageUrl)
        object = new PIXI.Sprite(texture)
      }
    } else if (animatedSprite) {
      const { image_url: imageUrl, frames } = animatedSprite
      const textures = this.createTextures(imageUrl, frames)
      object = new PIXI.extras.AnimatedSprite(textures)
    }
    if (parent) {
      this.parent = object
    }
    if (children) {
      Object.keys(children).forEach(name => {
        object.addChild(this.createObject(name, children[name]))
      })
    }
    this.objects[name] = object
    return object
  }

  createTextures(imageUrl, frames) {
    const base = PIXI.Texture.fromImage(imageUrl)
    return frames.map(({ x, y, width, height }) => {
      const rect = new PIXI.Rectangle(x, y, width, height)
      return new PIXI.Texture(base, rect)
    })
  }

  applyState(state) {
    Object.keys(state).forEach(name => {
      this.applyObjectState(name, state[name])
    })
  }

  applyObjectState(name, state) {
    const object = this.objects[name]
    Object.keys(state).forEach(name => {
      const value = state[name]
      if (name == 'x') {
        object.position.x = value
      } else if (name == 'y') {
        object.position.y = value
      } else if (name == 'scale_x') {
        object.scale.x = value
      } else if (name == 'scale_y') {
        object.scale.y = value
      } else if (name == 'origin_x') {
        object.pivot.x = value
      } else if (name == 'origin_y') {
        object.pivot.y = value
      } else if (name == 'anchor_x') {
        object.anchor.x = value
      } else if (name == 'anchor_y') {
        object.anchor.y = value
      } else if (name == 'animation_speed') {
        object.animationSpeed = value
      } else if (name == 'play') {
        if (value) {
          object.play()
        } else {
          object.stop()
        }
      } else if (DIRECTRY_UPDATE_KEYS.includes(name)) {
        object[name] = value
      } else {
        console.error('unknown state for zpid object')
      }
    })
  }
}

export default ZpidObject
