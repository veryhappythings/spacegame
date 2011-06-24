class Bullet < Renderable
  SPEED = 100

  def initialize(state, x, y, angle)
    super()
    @state = state
    @window = @state.window
    if @window
      @image = Gosu::Image.new(@window, 'media/bullet.png', false)
    end
    @angle = angle
    @x = x
    @y = y

    # Substitute for server not having an image to work from
    @width = 10
    @height = 100

    @state.scene_controller.register(self)
  end

  def update(dt)
    @x += Gosu::offset_x(@angle, SPEED) * dt
    @y += Gosu::offset_y(@angle, SPEED) * dt

    @state.scene_controller.objects.each do |object|
      if collides_with? object
        destroy
        object.hit_by(self)
      end
    end
    # Inform server of update
    return true
  end
end

