class Player < Renderable
  SPEED = 50
  DECELERATION = 10

  attr_accessor :velocity, :angle, :movement_angle
  attr_reader :client_id

  def initialize(state, x, y, angle, client_id)
    super()
    @state = state
    @window = state.window
    @image = nil
    if @window
      @image = Gosu::Image.new(@window, 'media/player.png', false)
    end
    @health = 100
    @x = x
    @y = y
    @angle = angle
    @collidable = true
    @client_id = client_id

    # Substitute for server not having an image to work from
    @width = 50
    @height = 50

    @velocity = 0
    @movement_angle = angle
  end

  def relative_to_absolute(x, y)
    # from map to window
    abs_x = x + (@state.camera.x - @window.width / 2)
    abs_y = y + (@state.camera.y - @window.height / 2)
    return abs_x, abs_y
  end

  def absolute_to_relative(x, y)
    # from window to map
    rel_x = x - @state.camera.x + @window.width / 2
    rel_y = y - @state.camera.y + @window.height / 2
    return rel_x, rel_y
  end

  def damage(value)
    @health -= value
    if @health <= 0
      destroy
    end
  end

  def hit_by(object)
    if object.is_a? Bullet
      damage(100)
      if @health <= 0
        @state.scores[self.client_id][:deaths] += 1
        @state.scores[@state.scene_controller.find(object.creator).client_id][:kills] += 1
      end
    end
  end

  def update(dt)
    old_x = x
    old_y = y
    @x += Gosu::offset_x(@movement_angle, @velocity) * dt
    @y += Gosu::offset_y(@movement_angle, @velocity) * dt

    if @velocity > 0
      @velocity -= DECELERATION * dt
    end
    if (-1..1).include?(@velocity)
      @movement_angle = @angle
    end
    if @velocity < 0
      @velocity += DECELERATION * dt
    end

    @state.scene_controller.nearby(self).each do |object|
      if collides_with?(object) && object.collidable?
        @x = old_x
        @y = old_y
        @velocity = 0
        break
      end
    end

    return true
  end
end

