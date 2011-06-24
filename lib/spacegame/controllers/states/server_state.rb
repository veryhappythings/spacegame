class ServerState < State
  attr_accessor :objects
  attr_accessor :scene_controller
  attr_accessor :server

  def initialize
    @scene_controller = SceneController.new(self)
    @server = nil
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
