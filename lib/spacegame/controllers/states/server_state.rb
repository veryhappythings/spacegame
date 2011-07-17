class ServerState < State
  attr_accessor :objects
  attr_accessor :scene_controller
  attr_accessor :server
  attr_accessor :scores

  def initialize
    super
    @scene_controller = ServerSceneController.new(self)
    @server = SpacegameNetworkServer.new(self)

    @scores = {}
    @scheduled_messages = []
  end

  def update(dt)
    to_delete = []
    @scheduled_messages.each do |msg|
      msg[:seconds] -= dt
      if msg[:seconds] <= 0
        msg[:message].options[:timestamp] = timestamp
        @server.on_msg(@server.socket, msg[:message])
        to_delete << msg
      end
    end
    to_delete.each {|m| @scheduled_messages.delete(m)}

    updated_objects = @scene_controller.update(dt)
    @server.update(dt, updated_objects)
  end

  def destroy(object)
    @scene_controller.destroy(object)
    @server.destroy(object)
  end

  def create_object(klass, x, y, angle, creator)
    @server.on_msg(@server.socket, CreateObject.new(
      :klass => klass,
      :x => x,
      :y => y,
      :angle => angle,
      :timestamp => @server.timestamp,
      :creator => creator
    ))
  end

  def schedule_message(message, seconds)
    puts "Scheduled #{message} for #{seconds} time"
    @scheduled_messages << {:message => message, :seconds => seconds}
  end

  def start
    @server.start
  end

  def timestamp
    @server.timestamp
  end

  def window
    nil
  end
end
