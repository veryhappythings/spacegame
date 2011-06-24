# The SceneController knows about everything that is going on
# in the scene. If anything wants to know what's in the scene,
# it should ask here. Also handles rendering and updating.
class SceneController
  attr_accessor :window, :objects

  def initialize(state)
    @objects = []
    @state = state
    @window = @state.window
    @dirty_objects = []
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

  def mark_as_dirty(object)
    @dirty_objects << object
  end

  def update(dt)
    updated_objects = Array.new(@dirty_objects).tap do |updated_objects|
      @objects.each do |object|
        if object.update(dt) || object.destroyed?
          updated_objects << object
        end
      end
    end
    @dirty_objects = []
    updated_objects
  end

  def send_event(event)
    @objects.each do |object|
      object.process_event(event)
    end
  end

  def player
    @objects.find {|o| o.class == Player}
  end

  def nearby(object)
    # Stub method - one day, this will only give a relevant list of objects
    @objects.reject{|o| o == object }
  end

  def find(unique_id)
    @objects.find{|o| o.unique_id == unique_id}
  end
end

