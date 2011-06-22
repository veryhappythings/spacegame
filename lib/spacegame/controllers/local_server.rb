class LocalServer
  attr_reader :events, :received_events

  def initialize
    @clients = {}
    @events = []
    @objects = []
    @state = ServerState.new()
    @received_events = []
  end

  def send_event(event)
    Utils.logger.info("Server received event #{event.to_s}")
    Utils.logger.info("#{event.options[:timestamp]}, #{event.options[:timestamp].class}")
    @received_events << event
    case event.name
    when :connect
      @clients[event.options[:client_id]] = event.options[:timestamp]
      player = Player.new(@state)
      @objects << player
      @events << Event.new(
        :create_object,
        :object => :player,
        :timestamp => event.options[:timestamp]
      )
    when :move
      player = @objects.find {|o| o.class == Player}
      if player
        x = event.options[:right_move] #* event.options[:simulation_time]
        y = event.options[:up_move] #* event.options[:simulation_time]
        angle = 0
        player.warp(player.x + x, player.y + y, angle)
        @events << Event.new(
          :warp,
          :object => :player,
          :x => object.x,
          :y => object.y,
          :angle => player.angle,
          :timestamp => event.options[:timestamp]
        )
      end
    else
      Utils.logger.warn("I don't know how to handle this: #{event.to_s}")
    end

    @events.each do |e|
      puts e.name
      puts e.options
      puts e.options[:timestamp]
      puts e.options[:timestamp].class
    end
  end

  def send_events(events)
    events.each {|e| send_event(e)}
  end

  def receive_events(client_id)
    # Simulate a server thread tick.  Will need rethinking for proper client/server
    #
    #events = @events.tap do |array|
    #  @objects.each do |object|
    #    # FIXME: Use object ID
    #    array << Event.new(:warp, :object => :player, :x => object.x, :y => object.y)
    #  end
    #end

    Utils.logger.info("Server sending events to #{client_id}")
    events = @events.select {|e| e.options[:timestamp].to_i >= @clients[client_id]}
    return events
  end
end
