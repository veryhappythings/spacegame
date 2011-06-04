class LocalServer
  def initialize
    @events = []
    @objects = []
    @state = ServerState.new()
  end

  def send_event(event)
    puts event.to_s
    case event.name
    when :connect
      player = Player.new(@state)
      @objects << player
      @events << Event.new(:create_object, :object => :player)
    else
      @events << event
    end
  end

  def send_events(events)
    events.each {|e| send_event(e)}
  end

  def receive_events
    return @events
  end
end
