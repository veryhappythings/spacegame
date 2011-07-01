class Spacejunk < Renderable
  def initialize(state, x, y)
    super()
    @state = state
    @window = @state.window
    @x = x
    @y = y
    if @window
      @image = Gosu::Image.new(@window, 'media/spacejunk10.png')
    end
    @height = 10
    @width = 10

    @collidable = false
  end

  def hit_by(object)
    if object.is_a? Player
      destroy
      object.pick_up(self)
      @state.scene_controller.mark_as_dirty(self)
    end
  end
end
