class SpacegameNetworkServer < NetworkServer
  # Not yet sure how to attach sockets to particular players
  attr_accessor :clients

  def initialize(state, options={})
    super(options)
    @state = state
    @state.server = self
    @clients = {}
    @simulation_time = 0
    @timestamp = (Time.now.to_f * 100000).to_i
    @pending_move_messages = []
  end

  def on_connect(socket)
    super(socket)
  end

  def update(simulation_time)
    super()
    @timestamp = (Time.now.to_f * 100000).to_i

    [].tap do |handled_messages|
      @pending_move_messages.each do |msg|
        msg.process(@state, simulation_time)
        handled_messages << msg
      end
    end.each do |msg|
      @pending_move_messages.delete msg
    end

    updated_objects = @state.update(simulation_time)
    updated_objects.each do |obj|
      broadcast_msg(Warp.new(
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
      msg.process(@state)
    when :create_object
      msg.process(@state)
    when :move
      @pending_move_messages << msg
    else
      Utils.logger.warn("Server: I don't know how to handle this: #{msg.to_s}")
    end
  end
end
