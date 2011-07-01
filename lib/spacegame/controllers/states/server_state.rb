class ServerState < State
  attr_accessor :objects
  attr_accessor :scene_controller
  attr_accessor :server
  attr_accessor :scores

  def initialize
    @scene_controller = ServerSceneController.new(self)
    @server = nil
    @scores = {}
  end

  def update(dt)
    @scene_controller.update(dt)
  end

  def destroy(object)
    @scene_controller.destroy(object)
    @server.destroy(object)
  end

  def window
    nil
  end
end
