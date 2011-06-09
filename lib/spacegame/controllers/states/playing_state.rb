class PlayingState < State
  attr_reader :window
  attr_reader :keyboard_controller
  attr_reader :scene_controller
  attr_reader :timestamp, :simulation_time
  attr_reader :server
  attr_reader :player

  attr_accessor :camera

  def initialize(window)
    @window = window

    @keyboard_controller = KeyboardController.new(self)
    @scene_controller = SceneController.new(self)

    @timestamp = (Time.now.to_f * 100000).to_i
    @simulation_time = 0

    @camera = Point.new(0, 0)

    @server = LocalServer.new
    Utils.logger.info("Connecting...")
    @server.send_event(Event.new(:connect))
  end

  def end_game!(score)
    @window.pop_state!
    @window.current_game_state.custom_message = "Game over! Score: #{score}"
  end

  def draw
    @scene_controller.draw(@camera)
  end

  def update(dt)
    start_time = Time.now.to_f

    # Controls
    events = @keyboard_controller.update(dt)

    # Send events
    @server.send_events(events)

    # Receive events
    receive_server_events

    # TODO: Move this somewhere!
    #if @player
    #  @camera.x = @player.x
    #  @camera.y = @player.y
    #end

    end_time = Time.now.to_f

    @simulation_time = end_time - start_time
  end

  def receive_server_events
    events = @server.receive_events
    processed_events = []

    events.each do |event|
      if event.options[:timestamp] > @timestamp
        handle_event(event)
        processed_events << event
      end
    end

    @timestamp = events.last.options[:timestamp]

    processed_events
  end

  def handle_event(event)
    Utils.logger.info("Client handling event: #{event.to_s}")
    case event.name
    when :create_object
      if event.options[:object] == :player
        @player = Player.new(self)
        @keyboard_controller.register(@player)
        @scene_controller.register(@player)
      else
        Utils.logger.warn("I don't know how to create #{event.options[:object]}")
      end
    when :warp
      if event.options[:object] == :player && @player
        @player.warp(event.options[:x], event.options[:y])
      end
    else
      Utils.logger.warn("I don't know how to handle event: #{event.to_s}")
    end
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

