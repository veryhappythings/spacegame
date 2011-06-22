class Renderable
  @@unique_id_counter = 0
  attr_reader :x, :y, :angle
  attr_accessor :unique_id

  def initialize(options={})
    @x = @y = @angle = 0.0
    @unique_id = @@unique_id_counter + 1
    @@unique_id_counter += 1
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

  def draw(camera)
    if @window && @image
      draw_x = @x - camera.x + @window.width / 2
      draw_y = @y - camera.y + @window.height / 2
      @image.draw_rot(draw_x, draw_y, 1, @angle)
    end
  end

  def update(dt)
    false
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

  def process_event(event)

  end
end

