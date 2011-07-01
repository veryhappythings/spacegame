class Enemy < Renderable
  SPEED = 50
  DECELERATION = 10

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

    # Substitute for server not having an image to work from
    @width = 50
    @height = 50

    @velocity = 0
    @vx, @vy = 0, 0
    @thrust_direction = 0
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
      @angle = Gosu::angle(@x, @y, nearest_player.x, nearest_player.y)
      @thrust_direction = 1
    end

    # Movement
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
