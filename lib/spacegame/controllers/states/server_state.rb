class ServerState < State
  attr_accessor :objects
  attr_accessor :scene_controller
  attr_accessor :server

  def initialize
    @scene_controller = SceneController.new(self)
  end

  def update(dt)
    @scene_controller.update(dt)
  end

  def window
    nil
  end
end
