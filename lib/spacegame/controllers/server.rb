class SpacegameNetworkServer < NetworkServer
  # Not yet sure how to attach sockets to particular players

  def initialize(state, options={})
    super(options)
    @state = state
    @clients = {}
  end

  def on_connect(socket)
    super(socket)

  end

  def on_msg(socket, msg)
    socket_id = @sockets.find_index {|s| s == socket}
    Utils.logger.info("Server received message from #{socket_id}: #{msg}")

    case msg.name
    when :connect
      @clients[msg.options[:client_id]] = msg.options[:timestamp]
      player = Player.new(@state)
      @state.objects << player
      broadcast_msg(Event.new(
        :create_object,
        :object => :player,
        :timestamp => msg.options[:timestamp]
      ))
    when :move
      # FIXME: work for multiple players
      player = @state.objects.find {|o| o.class == Player}
      if player
        up_move = msg.options[:up_move]
        angle = msg.options[:angle]
        # Only up_move is used because left/right is controlled by angle
        x_movement = Gosu::offset_x(player.angle + angle, Player::SPEED * up_move) * msg.options[:simulation_time] * 10
        y_movement = Gosu::offset_y(player.angle + angle, Player::SPEED * up_move) * msg.options[:simulation_time] * 10
        player.warp(player.x + x_movement, player.y + y_movement, player.angle + angle)
        broadcast_msg(Event.new(
          :warp,
          :object => :player,
          :x => player.x,
          :y => player.y,
          :angle => player.angle,
          :timestamp => msg.options[:timestamp]
        ))
      end
    else
      Utils.logger.warn("Server: I don't know how to handle this: #{msg.to_s}")
    end

  end
end
