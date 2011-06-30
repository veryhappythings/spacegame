class SpaceTile < Renderable
  def initialize(state, x, y)
    super()
    @state = state
    @window = @state.window
    @x = x
    @y = y
    if @window
      @image = Gosu::Image.new(@window, 'media/stars200.png')
    end
  end

  def draw(camera)
    super(camera, 0)
  end
end
