class PlayingState < State
  attr_reader :window
  attr_reader :keyboard_controller
  attr_reader :scene_controller
  attr_reader :timestamp, :simulation_time
  attr_reader :server, :client
  attr_reader :player

  attr_accessor :camera

  def initialize(window)
    @window = window

    @keyboard_controller = KeyboardController.new(self)
    @scene_controller = SceneController.new(self)

    @timestamp = (Time.now.to_f * 100000).to_i
    @simulation_time = 0
    @camera = Point.new(0, 0)

    @use_local_server = true
    if @use_local_server
      @server = SpacegameNetworkServer.new(ServerState.new)
      @server.start
    end
    @client = SpacegameNetworkClient.new(self)
    @client.connect

    @client_id = "localclient"

    Utils.logger.info("Playing State init complete.")
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

    # Send events
    if !@connect_request_sent
      @connect_request_sent = true
      if @use_local_server
        @server.update
      end
      @client.update
      @client.send_msg(Event.new(:connect, :client_id => @client_id, :timestamp => @timestamp))
    end

    @keyboard_controller.update(dt).each do |event|
      @client.send_msg(event)
    end

    # Receive events
    if @use_local_server
      @server.update
    end

    # Send events
    @client.update

    end_time = Time.now.to_f

    @simulation_time = end_time - start_time
  end

  def handle_event(event)
    Utils.logger.info("Client handling event: #{event.to_s}")
    case event.name
    when :create_object
      case event.options[:class]
      when :player
        @player = Player.new(self)
        @player.unique_id = event.options[:unique_id]
        @keyboard_controller.register(@player)
        @scene_controller.register(@player)
      when :bullet
        bullet = Bullet.new(self, event.options[:x], event.options[:y], event.options[:angle])
        bullet.unique_id = event.options[:unique_id]
        @scene_controller.register(bullet)
      else
        Utils.logger.warn("I don't know how to create #{event.options[:object]}")
      end
    when :warp
      if object = @scene_controller.find(event.options[:unique_id])
        object.warp(event.options[:x], event.options[:y], event.options[:angle])
      end
    else
      Utils.logger.warn("I don't know how to handle event: #{event.to_s}")
    end
  end

  # Controls
  def button_down(id)
    @keyboard_controller.button_down(id)
  end

  def button_up(id)
    @keyboard_controller.button_up(id)
  end
end

