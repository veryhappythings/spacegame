class SpacegameNetworkServer < NetworkServer
  # Not yet sure how to attach sockets to particular players

  def initialize(state, options={})
    super(options)
    @state = state
    @clients = {}
    @simulation_time = 0
    @timestamp = (Time.now.to_f * 100000).to_i
    @pending_move_messages = []
  end

  def on_connect(socket)
    super(socket)
  end

  def handle_move_msg(simulation_time, msg)
    player = @state.scene_controller.find(msg.options[:unique_id])
    if player
      up_move = msg.options[:up_move]
      angle = msg.options[:angle]
      # Only up_move is used because left/right is controlled by angle
      x_movement = Gosu::offset_x(player.angle + angle, Player::SPEED * up_move) * simulation_time
      y_movement = Gosu::offset_y(player.angle + angle, Player::SPEED * up_move) * simulation_time
      player.warp(player.x + x_movement, player.y + y_movement, player.angle + angle)
      @state.scene_controller.mark_as_dirty(player)
    end
  end

  def update(simulation_time)
    super()
    @timestamp = (Time.now.to_f * 100000).to_i

    [].tap do |handled_messages|
      @pending_move_messages.each do |msg|
        handle_move_msg(simulation_time, msg)
        handled_messages << msg
      end
    end.each do |msg|
      @pending_move_messages.delete msg
    end

    updated_objects = @state.update(simulation_time)
    updated_objects.each do |obj|
      broadcast_msg(Event.new(
        :warp,
        :unique_id => obj.unique_id,
        :x => obj.x,
        :y => obj.y,
        :angle => obj.angle,
        :timestamp => @timestamp,
        :simulation_time => simulation_time
      ))
    end
  end

  def on_msg(socket, msg)
    socket_id = @sockets.find_index {|s| s == socket}
    Utils.logger.info("Server received message from #{socket_id}: #{msg}")

    case msg.name
    when :connect
      if @clients.has_key? msg.options[:client_id]
        Utils.logger.error("SERVER: client with ID #{msg.options[:client_id]} already exists!")
      end

      @clients[msg.options[:client_id]] = msg.options[:timestamp]
      player = Player.new(@state, 0, 0, 0)
      @state.scene_controller.register(player)

      broadcast_msg(player.to_msg(msg.options[:client_id], msg.options[:timestamp]))
      @state.scene_controller.objects.each do |object|
        unless object == player
          send_msg(socket, object.to_msg(nil, msg.options[:timestamp]))
        end
      end
    when :create_object
      case msg.options[:class]
      when :bullet
        bullet = Bullet.new(@state, msg.options[:x], msg.options[:y], msg.options[:angle])
        @state.scene_controller.register(bullet)
        broadcast_msg(bullet.to_msg(nil, msg.options[:timestamp]))
      else
        Utils.logger.warn("Server: I don't know how to create a #{msg[:object]}")
      end
    when :move
      @pending_move_messages << msg
    else
      Utils.logger.warn("Server: I don't know how to handle this: #{msg.to_s}")
    end
  end
end
