class Renderable
  attr_reader :x, :y
  attr_reader :game_id

  def initialize(options={})
    @game_id = 0
  end

  def width
    @image.width
  end

  def height
    @image.height
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

  def draw(camera)
    if @window && @image
      draw_x = @x - camera.x + @window.width / 2
      draw_y = @y - camera.y + @window.height / 2
      @image.draw_rot(draw_x, draw_y, 1, @angle)
    end
  end

  def update(dt)
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

