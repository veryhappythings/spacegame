class Renderable
  @@unique_id_counter = 0
  attr_reader :x, :y, :angle
  attr_accessor :unique_id
  attr_reader :creator

  def initialize(options={})
    @x = @y = @angle = 0.0
    @destroyed = false
    @unique_id = @@unique_id_counter + 1
    @@unique_id_counter += 1
    @collidable = false
    @creator = nil
  end

  def width
    if @width
      @width
    elsif @image
      @image.width
    else
      0
    end
  end

  def height
    if @height
      @height
    elsif @image
      @image.height
    else
      0
    end
  end

  def top
    @y - height / 2
  end

  def bottom
    @y + height / 2
  end

  def left
    @x - width / 2
  end

  def right
    @x + width / 2
  end

  def warp(x, y, angle)
    @x, @y, @angle = x, y, angle
  end

  def draw(camera, z=1)
    if @window && @image
      draw_x = @x - camera.x + @window.width / 2
      draw_y = @y - camera.y + @window.height / 2
      @image.draw_rot(draw_x, draw_y, z, @angle)
    end
  end

  def destroy
    @destroyed = true
  end
  def destroyed?
    @destroyed
  end

  def update(dt)
    false
  end

  def collidable?
    @collidable
  end

  def collides_with?(renderable)
    if not renderable.kind_of?(Renderable)
      false
    else
      !(bottom < renderable.top ||
        top > renderable.bottom ||
        right < renderable.left ||
        left > renderable.right)
    end
  end

  def hit_by(object)

  end

  def process_event(event)

  end

  def to_msg(client_id, timestamp)
    CreateObject.new(
      :klass => self.class.to_s.underscore.to_sym,
      :client_id => client_id,
      :unique_id => @unique_id,
      :x => @x,
      :y => @y,
      :angle => @angle,
      :timestamp => timestamp,
      :creator => @creator
    )
  end
end

