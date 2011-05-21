class Player < Renderable
  SPEED = 100

  attr_reader :score

  def initialize(state)
    @state = state
    @window = state.window
    @image = Gosu::Image.new(@window, 'media/player.png', false)
    @x = @y = @angle = 0.0

    @health = 100
    @score = 0

    @state.keyboard_controller.register(self)
    @state.scene_controller.register(self)
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def update(dt)
    look_x, look_y = @state.relative_to_absolute(@state.window.mouse_x, @state.window.mouse_y)
    @angle = Gosu::angle(@x, @y, look_x, look_y)

    if @health <= 0
      destroy!
    end
  end

  def handle_event(event)
    case event.name
    when :kb_left_down then
      move_left(event.options[:dt])
    when :kb_right_down then
      move_right(event.options[:dt])
    when :kb_up_down then
      move_forwards(event.options[:dt])
    when :kb_down_down then
      move_backwards(event.options[:dt])
    when :kb_space_down then
      shoot
    when :mouse_left_down then
      shoot
    when :game_killed_zombie then
      @score += 1
    end
  end

  def turn_left(dt)
    @angle -= 90 * dt
  end

  def turn_right(dt)
    @angle += 90 * dt
  end

  def move_forwards(dt)
    move(dt, :up)
  end
  def move_backwards(dt)
    move(dt, :down)
  end
  def move_left(dt)
    move(dt, :left)
  end
  def move_right(dt)
    move(dt, :right)
  end
  def move(dt, direction)
    # TODO: Move wall collision calculations into physics model
    case direction
    when :left
      x_movement = -SPEED * dt
      y_movement = 0
    when :right
      x_movement = SPEED * dt
      y_movement = 0
    when :up
      x_movement = 0
      y_movement = -SPEED * dt
    when :down
      x_movement = 0
      y_movement = SPEED * dt
    end

    @x += x_movement
    @y += y_movement
    @state.scene_controller.nearby(self).each do |object|
      if collides_with? object
        @x -= x_movement
        @y -= y_movement
        break
      end
    end
  end

  def shoot

  end

  def destroy!
    @state.end_game! @score
  end

  def damage(value)
    @health -= value
  end
end

