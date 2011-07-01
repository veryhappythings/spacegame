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
    @level_objects = [].tap do |level_objects| # 800x600 - 4x3
      (-2..3).each do |x|
        (-2..2).each do |y|
          level_objects << SpaceTile.new(@state, x * 200, y * 200, rand(3)*90)
        end
      end
    end

    # FIXME: Move level building somewhere sensible
    if state.is_a? ServerState
      register(Block.new(@state, 100, 100))
      register(Spacejunk.new(@state, -50, -50))
    end
  end

  def register(object)
    @objects << object
  end

  def deregister(object)
    @objects.delete object
  end

  def draw(camera)
    @level_objects.each do |object|
      object.draw(camera)
    end
    @objects.each do |object|
      object.draw(camera)
    end
  end

  def mark_as_dirty(object)
    @dirty_objects << object
  end

  def visual_update(dt)
    # Visual effects
    if @window
      @level_objects.each do |object|
        rel_x, rel_y = absolute_to_relative(object.x, object.y)
        if rel_y > @window.height + object.height
          object.warp(object.x, object.y - @window.height - object.width*2, rand(3)*90)
        elsif rel_y < 0 - object.height
          object.warp(object.x, object.y + @window.height + object.width*2, rand(3)*90)
        end
        if rel_x > @window.width + object.width
          object.warp(object.x - @window.width - object.width*2, object.y, rand(3)*90)
        elsif rel_x < 0 - object.width
          object.warp(object.x + @window.width + object.width*2, object.y, rand(3)*90)
        end

      end
    end
  end

  def update(dt)
    # Server relevant
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

  def relative_to_absolute(x, y)
    # from postio on window to position on map
    abs_x = x + (@state.camera.x - @window.width / 2)
    abs_y = y + (@state.camera.y - @window.height / 2)
    return abs_x, abs_y
  end

  def absolute_to_relative(x, y)
    # From position on map to position on window
    rel_x = x - @state.camera.x + @window.width / 2
    rel_y = y - @state.camera.y + @window.height / 2
    return rel_x, rel_y
  end
end

