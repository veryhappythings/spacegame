class PlayingState < State
  attr_reader :window
  attr_reader :keyboard_controller
  attr_reader :scene_controller
  attr_reader :timestamp, :simulation_time
  attr_reader :server_state, :client
  attr_reader :client_id

  attr_accessor :player
  attr_accessor :camera
  attr_accessor :scores

  ACCEPT_MESSAGES = [:create_object, :warp, :destroy, :scores, :inventory]

  def initialize(window)
    super
    @window = window

    @timestamp = (Time.now.to_f * 100000).to_i
    @simulation_time = 0
    @scores = {}
    @camera = Point.new(0, 0)
    @client_id = @timestamp.to_s

    @keyboard_controller = KeyboardController.new(self)
    @scene_controller = SceneController.new(self)

    @use_local_server = true
    if @use_local_server
      @server_state = ServerState.new
      add_substate @server_state
      @server_state.start
    end
    @client = SpacegameNetworkClient.new(self)
    @client.connect


    @font_size = 20
    @font = Gosu::Font.new(@window, Gosu::default_font_name, @font_size)

    Utils.logger.info("Playing State init complete.")
  end

  def end_game!(score)
    @window.pop_state!
    @window.current_game_state.custom_message = "Game over! Score: #{score}"
  end

  def draw
    super()
    @scene_controller.draw(@camera)

    if @player
      @player.inventory.each_key.each_with_index do |name, i|
        @font.draw(name, 10, 20*i, 0)
        @font.draw(@player.inventory[name], 150, 20*i, 0)
      end
    end
  end

  def connect
    @connect_request_sent = true
    if @use_local_server
      @server_state.update(@simulation_time)
    end
    @client.update
    @client.send_msg(Connect.new(:client_id => @client_id, :timestamp => @timestamp))
  end

  def update(dt)
    start_time = Time.now.to_f

    # Send events
    if !@connect_request_sent
      connect
    end

    @keyboard_controller.update(dt).each do |event|
      @client.send_msg(event)
    end

    # Execute substates
    super(dt)

    # Send events
    @client.update

    if @player
      @camera.x = @player.x
      @camera.y = @player.y
    end
    @scene_controller.visual_update(dt)

    end_time = Time.now.to_f

    @simulation_time = end_time - start_time + dt
  end

  def handle_msg(msg)
    #Utils.logger.info("Client handling msg: #{msg.to_s}")
    if ACCEPT_MESSAGES.include? msg.name
      msg.process(self)
    else
      Utils.logger.warn("I don't know how to handle msg: #{msg.to_s}")
    end
  end

  # Controls
  def button_down(id)
    super
    @keyboard_controller.button_down(id)
  end

  def button_up(id)
    super
    @keyboard_controller.button_up(id)
  end
end

