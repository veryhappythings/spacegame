class Player < Renderable
  SPEED = 100

  attr_reader :score

  def initialize(state)
    super
    @state = state
    @window = state.window
    @image = nil
    if @window
      @image = Gosu::Image.new(@window, 'media/player.png', false)
    end
    @x = @y = @angle = 0.0

    @health = 100
    @score = 0
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

  def update(dt)
    if @health <= 0
      destroy!
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

  def process_event(event)
    if event.name == :move
      puts event.options
    end
  end
end

