const DIRECTRY_UPDATE_KEYS = [
  'x', 'y', 'rotation', 'visible', 'alpha',
  'interactive', 'animationSpeed']

class ZpidObject {
  constructor(object) {
    this.object = object
    this.sprites = {}
    const { sprites, state } = object
    this.container = new PIXI.Container()
    Object.keys(sprites).forEach(name => {
      this.container.addChild(this.createSprite(name, sprites[name]))
    })
    this.applyState(state)
  }

  createSprite(name, { imageUrl, frames, children }) {
    const base = PIXI.Texture.fromImage(imageUrl)
    const textures = frames.map(rect => {
      return new PIXI.Texture(base, rect)
    })
    const sprite = textures.length == 1
      ? new PIXI.Sprite(textures[0])
      : new PIXI.extras.AnimatedSprite(textures)
    if (children) {
      Object.keys(children).forEach(name => {
        sprite.addChild(this.createSprite(name, children[name]))
      })
    }
    this.sprites[name] = sprite
    return sprite
  }

  applyState(state) {
    Object.keys(state).forEach(name => {
      this.applySpriteState(name, state[name])
    })
  }

  applySpriteState(name, state) {
    const sprite = this.sprites[name]
    Object.keys(state).forEach(name => {
      const value = state[name]
      if (name == 'x') {
        sprite.position.x = value
      } else if (name == 'y') {
        sprite.position.y = value
      } else if (name == 'width') {
        sprite.scale.x = value / sprite.texture.width
      } else if (name == 'height') {
        sprite.scale.y = value / sprite.texture.height
      } else if (name == 'pivot') {
        sprite.pivot.x = value.x
        sprite.pivot.y = value.y
      } else if (name == 'anchor') {
        sprite.anchor.x = value.x
        sprite.anchor.y = value.y
      } else if (name == 'play') {
        if (value) {
          sprite.play()
        } else {
          sprite.stop()
        }
      } else if (DIRECTRY_UPDATE_KEYS.includes(name)) {
        sprite[name] = value
      } else {
        console.error('unknown state for zpid object')
      }
    })
  }
}

export default ZpidObject
