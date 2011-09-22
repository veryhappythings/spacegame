class SpacegameWindow < GameWindow
  def initialize
    super
    self.caption = 'Spacegame'
    @state_stack << MenuState.new(self)
  end

  def new_game!
    @state_stack = [
      MenuState.new(self),
      PlayingState.new(self)
    ]
  end

  def in_game?
    @state_stack.find {|state| state.class == PlayingState}
  end
end
