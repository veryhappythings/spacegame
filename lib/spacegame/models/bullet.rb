class Bullet < Renderable
  SPEED = 100

  def initialize(state, x, y, angle, creator)
    super()
    @state = state
    @window = @state.window
    @creator = creator
    if @window
      @image = Gosu::Image.new(@window, 'media/bullet.png', false)
    end
    @angle = angle
    @x = x
    @y = y

    # Substitute for server not having an image to work from
    @width = 8
    @height = 16

    @state.scene_controller.register(self)
  end

  def update(dt)
    @x += Gosu::offset_x(@angle, SPEED) * dt
    @y += Gosu::offset_y(@angle, SPEED) * dt

    @state.scene_controller.nearby(self).each do |object|
      if (object.unique_id != @creator) && collides_with?(object)
        destroy
        object.hit_by(self)
      end
    end
    # Inform server of update
    return true
  end
end

