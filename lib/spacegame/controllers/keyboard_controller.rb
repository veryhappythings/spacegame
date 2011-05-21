class KeyboardController
  attr_accessor :window

  def initialize(state)
    @listeners = []
    @state = state
    @window = @state.window
    @buttons_down = []
  end

  def register(object)
    @listeners << object
  end

  def deregister(object)
    @listeners.delete object
  end

  def send_event(name)
    event = Event.new(name)
    @listeners.each do |l|
      l.handle_event(event)
    end
  end

  def button_down(id)
    @buttons_down << id
  end

  def button_up(id)
    @buttons_down.delete id
  end

  def button_down?(id)
    @buttons_down.include? id
  end

  def update(dt)
    controls = {
      :kb_left_down => [Gosu::Button::KbLeft, Gosu::Button::KbA],
      :kb_right_down => [Gosu::Button::KbRight, Gosu::Button::KbD],
      :kb_up_down => [Gosu::Button::KbUp, Gosu::Button::KbW],
      :kb_down_down => [Gosu::Button::KbDown, Gosu::Button::KbS],
    }
    controls.each_pair do |signal, keys|
      if keys.any? { |key| button_down? key }
        @listeners.each do |l|
          l.handle_event(Event.new(:kb_left_down, :dt => dt))
        end
      end
    end
  end
end

