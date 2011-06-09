class LocalServer
  attr_reader :events, :received_events

  def initialize
    @events = []
    @objects = []
    @state = ServerState.new()
    @received_events = []
  end

  def send_event(event)
    Utils.logger.info("Server received event #{event.to_s}")
    @received_events << event
    case event.name
    when :connect
      player = Player.new(@state)
      @objects << player
      @events << Event.new(:create_object, :object => :player)
    when :move
      player = @objects.find {|o| o.class == Player}
      if player
        x = event.options[:right_move] #* event.options[:simulation_time]
        y = event.options[:up_move] #* event.options[:simulation_time]
        player.warp(player.x + x, player.y + y)
      end
    else
      Utils.logger.warn("I don't know how to handle this: #{event.to_s}")
    end
  end

  def send_events(events)
    events.each {|e| send_event(e)}
  end

  def receive_events
    # Simulate a server thread tick.  Will need rethinking for proper client/server
    #
    events = @events.tap do |array|
      @objects.each do |object|
        # FIXME: Use object ID
        array << Event.new(:warp, :object => :player, :x => object.x, :y => object.y)
      end
    end
  end
end
