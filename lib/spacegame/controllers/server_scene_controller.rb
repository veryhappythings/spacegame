class ServerSceneController
  attr_accessor :window, :objects

  def initialize(state)
    @objects = []
    @state = state
    @window = @state.window
    @dirty_objects = []

    (0..10).each do |i|
      block = Block.new(@state, rand(1000)-500, rand(1000)-500)
      register_if_well_placed block
    end

    (0..10).each do |i|
      junk = Spacejunk.new(@state, rand(1000)-500, rand(1000)-500)
      register_if_well_placed junk
    end
  end

  def register_if_well_placed(object)
    can_place = true
    nearby(object).each do |nearby_object|
      if object.collides_with? nearby_object
        can_place = false
        break
      end
    end
    register(object) if can_place
  end

  def register(object)
    @objects << object
  end

  def deregister(object)
    @objects.delete object
  end

  def draw(camera)
  end

  def mark_as_dirty(object)
    @dirty_objects << object
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

