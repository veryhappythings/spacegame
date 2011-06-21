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
    else
      Utils.logger.warn("I don't know how to handle this: #{msg.to_s}")
    end

  end
end
