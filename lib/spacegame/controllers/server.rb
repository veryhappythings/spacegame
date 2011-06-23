class SpacegameNetworkServer < NetworkServer
  # Not yet sure how to attach sockets to particular players

  def initialize(state, options={})
    super(options)
    @state = state
    @clients = {}
    @simulation_time = 0
    @timestamp = (Time.now.to_f * 100000).to_i
  end

  def on_connect(socket)
    super(socket)
  end

  def update(simulation_time)
    super()
    @timestamp = (Time.now.to_f * 100000).to_i
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

      broadcast_msg(Event.new(
        :create_object,
        :class => :player,
        :client_id => msg.options[:client_id],
        :unique_id => player.unique_id,
        :x => player.x,
        :y => player.y,
        :angle => player.angle,
        :timestamp => msg.options[:timestamp]
      ))
      @state.scene_controller.objects.each do |object|
        unless object == player
          send_msg(socket, Event.new(
            :create_object,
            :class => object.class.to_s.downcase.to_sym,
            :unique_id => object.unique_id,
            :x => object.x,
            :y => object.y,
            :angle => object.angle,
            :timestamp => msg.options[:timestamp]
          ))
        end
      end
    when :create_object
      case msg.options[:class]
      when :bullet
        bullet = Bullet.new(@state, msg.options[:x], msg.options[:y], msg.options[:angle])
        @state.scene_controller.register(bullet)
        broadcast_msg(Event.new(
          :create_object,
          :class => :bullet,
          :unique_id => bullet.unique_id,
          :x => bullet.x,
          :y => bullet.y,
          :angle => bullet.angle,
          :timestamp => msg.options[:timestamp]
        ))
      else
        Utils.logger.warn("Server: I don't know how to create a #{msg[:object]}")
      end
    when :move
      player = @state.scene_controller.find(msg.options[:unique_id])
      if player
        up_move = msg.options[:up_move]
        angle = msg.options[:angle]
        # Only up_move is used because left/right is controlled by angle
        x_movement = Gosu::offset_x(player.angle + angle, Player::SPEED * up_move) * msg.options[:simulation_time]
        y_movement = Gosu::offset_y(player.angle + angle, Player::SPEED * up_move) * msg.options[:simulation_time]
        player.warp(player.x + x_movement, player.y + y_movement, player.angle + angle)
        @state.scene_controller.mark_as_dirty(player)
      end
    else
      Utils.logger.warn("Server: I don't know how to handle this: #{msg.to_s}")
    end
  end
end
