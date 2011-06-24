class PlayingState < State
  attr_reader :window
  attr_reader :keyboard_controller
  attr_reader :scene_controller
  attr_reader :timestamp, :simulation_time
  attr_reader :server, :client
  attr_reader :client_id

  attr_accessor :player
  attr_accessor :camera

  ACCEPT_MESSAGES = [:create_object, :warp, :destroy]

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

    @client_id = @timestamp.to_s

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
        @server.update(@simulation_time)
      end
      @client.update
      @client.send_msg(Connect.new(:client_id => @client_id, :timestamp => @timestamp))
    end

    @keyboard_controller.update(dt).each do |event|
      @client.send_msg(event)
    end

    # Receive events
    if @use_local_server
      @server.update(@simulation_time)
    end

    # Send events
    @client.update

    end_time = Time.now.to_f

    @simulation_time = end_time - start_time + dt
  end

  def handle_msg(msg)
    Utils.logger.info("Client handling msg: #{msg.to_s}")
    if ACCEPT_MESSAGES.include? msg.name
      msg.process(self)
    else
      Utils.logger.warn("I don't know how to handle msg: #{msg.to_s}")
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

