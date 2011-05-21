# The SceneController knows about everything that is going on
# in the scene. If anything wants to know what's in the scene,
# it should ask here. Also handles rendering and updating.
class SceneController
  attr_accessor :window, :objects

  def initialize(state)
    @objects = []
    @state = state
    @window = @state.window
  end

  def register(object)
    @objects << object
  end

  def deregister(object)
    @objects.delete object
  end

  def draw(camera)
    @objects.each do |object|
      object.draw(camera)
    end
  end

  def update(dt)
    @objects.each do |object|
      object.update(dt)
    end
  end

  #def player
  #  @objects.find {|o| o.class == Player}
  #end

  def nearby(object)
    # Stub method - one day, this will only give a relevant list of objects
    @objects.reject{|o| o == object }
  end
end

