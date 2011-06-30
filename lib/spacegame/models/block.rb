class Block < Renderable
  def initialize(state, x, y)
    super()
    @state = state
    @window = @state.window
    @x = x
    @y = y
    if @window
      @image = Gosu::Image.new(@window, 'media/block25.png')
    end

    @collidable = true
  end
end
