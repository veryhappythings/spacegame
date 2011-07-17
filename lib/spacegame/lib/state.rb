class State
  def initialize(*args)
    @substates = []
  end

  def draw
    @substates.each {|s| s.draw}
  end

  def update(dt)
    @substates.each {|s| s.update(dt)}
  end

  def button_down(id)
    @substates.each {|s| s.button_down(id)}
  end

  def button_up(id)
    @substates.each {|s| s.button_up(id)}
  end

  def add_substate(state)
    @substates << state
  end
end

