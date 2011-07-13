class Player < Renderable
  SPEED = 50
  DECELERATION = 10

  attr_accessor :velocity, :angle, :movement_angle, :inventory
  attr_accessor :vx, :vy, :thrust_direction
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
    @vx, @vy = 0, 0
    @thrust_direction = 0
    @movement_angle = angle
    @inventory = {}
    @inventory.default = 0
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
      attacker = @state.scene_controller.find(object.creator)
      damage(100)
      if @health <= 0
        @state.scores[self.client_id][:deaths] += 1
        if attacker.respond_to? :client_id
          @state.scores[attacker.client_id][:kills] += 1
        end
      end
    end
  end

  def update(dt)
    old_x = x
    old_y = y
    @x += @vx * dt
    @y += @vy * dt

    @vx += Math.sin(Utils.degrees_to_radians(@angle)) * @thrust_direction
    @vy -= Math.cos(Utils.degrees_to_radians(@angle)) * @thrust_direction
    @thrust_direction = 0

    if @vx > 0
      @vx -= DECELERATION * dt
    end
    if @vy > 0
      @vy -= DECELERATION * dt
    end
    if @vx < 0
      @vx += DECELERATION * dt
    end
    if @vy < 0
      @vy += DECELERATION * dt
    end

    @state.scene_controller.nearby(self).each do |object|
      if collides_with?(object)
        if object.collidable?
          @x = old_x
          @y = old_y
          @vx, @vy = 0, 0
        end
        object.hit_by(self)
        break
      end
    end

    return true
  end

  def pick_up(object)
    @inventory[object.class.to_s.underscore.to_sym] += 1
    @state.server.broadcast_msg(Inventory.new(
      :client_id => @client_id,
      :inventory => @inventory,
      :timestamp => @state.server.timestamp
    ))
  end

  def degrees_to_radians(degrees)
    return degrees * Math::PI / 180
  end
end

