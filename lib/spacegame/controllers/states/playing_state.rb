class PlayingState < State
  attr_reader :window
  attr_reader :keyboard_controller
  attr_reader :scene_controller

  attr_accessor :camera

  def initialize(window)
    @window = window

    @keyboard_controller = KeyboardController.new(self)
    @scene_controller = SceneController.new(self)

    @player = Player.new(self)
    #@player.warp(400, 300)

    #@level = Level.new(self)

    @camera = Point.new(0, 0)

    @server = LocalServer.new
  end

  def end_game!(score)
    @window.pop_state!
    @window.current_game_state.custom_message = "Game over! Score: #{score}"
  end

  def draw
    @scene_controller.draw(@camera)
  end

  def relative_to_absolute(x, y)
    # from map to window
    abs_x = x + (@camera.x - @window.width / 2)
    abs_y = y + (@camera.y - @window.height / 2)
    return abs_x, abs_y
  end

  def absolute_to_relative(x, y)
    # from window to map
    rel_x = x - @camera.x + @window.width / 2
    rel_y = y - @camera.y + @window.height / 2
    return rel_x, rel_y
  end

  def update(dt)
    # Controls
    @keyboard_controller.update(dt)

    # Actions
    @scene_controller.update(dt)

    @camera.x = @player.x
    @camera.y = @player.y
  end

  def button_down(id)
    @keyboard_controller.button_down(id)
    case id
      when Gosu::Button::KbSpace then
        @keyboard_controller.send_event(:kb_space_down)
      when Gosu::Button::KbEscape then
        @window.enter_state MenuState.new(@window)
        @window.current_game_state.custom_message = 'Game paused!'
      when Gosu::Button::MsLeft then
        @keyboard_controller.send_event(:mouse_left_down)
    end
  end

  def button_up(id)
    @keyboard_controller.button_up(id)
  end
end

