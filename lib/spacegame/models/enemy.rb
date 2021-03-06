class Enemy < Renderable
  SPEED = 50
  DECELERATION = 10
  FIRING_RATE = 3

  attr_accessor :velocity, :angle, :movement_angle, :inventory
  attr_accessor :vx, :vy, :thrust_direction

  def initialize(state, x, y, angle)
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
    @time_since_last_shot = 0

    # Substitute for server not having an image to work from
    @width = 50
    @height = 50

    @velocity = 0
    @vx, @vy = 0, 0
    @thrust_direction = 0
  end

  def hit_by(object)
    if object.is_a? Bullet
      damage(100)
      if @health <= 0
        @state.scores[@state.scene_controller.find(object.creator).client_id][:kills] += 1
      end
    end
  end

  def damage(value)
    @health -= value
    if @health <= 0
      destroy
    end
  end

  def update(dt)
    # AI - find player, move towards, fire
    nearest_player = nil
    @state.scene_controller.players.each do |player|
      if !nearest_player
        nearest_player = player
      end
      if (player.x - @x).abs < (nearest_player.x - @x).abs && (player.y - @y).abs < (nearest_player.y - @y).abs
        nearest_player = player
      end
    end
    if nearest_player
      target_x, target_y = nearest_player.x, nearest_player.y
    else
      target_x, target_y = 1000, 1000
    end
    @angle = Gosu::angle(@x, @y, target_x, target_y)
    distance = Gosu::distance(@x, @y, target_x, target_y)

    if distance > 200
      @thrust_direction = 1
    end

    # Fire?
    if @time_since_last_shot > FIRING_RATE
      @state.create_object(
        :bullet,
        x,
        y,
        angle,
        unique_id
      )
      @time_since_last_shot = 0
    end
    @time_since_last_shot += dt

    # Normal update Movement
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

    # Not sure how to handle collision yet!
    #@state.scene_controller.nearby(self).each do |object|
    #  if collides_with?(object)
    #    if object.collidable?
    #      @x = old_x
    #      @y = old_y
    #      @vx, @vy = 0, 0
    #    end
    #    object.hit_by(self)
    #    break
    #  end
    #end

    return true
  end
end
