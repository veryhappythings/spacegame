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

    # Immediate actions
    case id
    when Gosu::Button::KbSpace then
      @state.client.send_msg(Event.new(:create_object, :object => :bullet, :x => 0, :y => 0, :angle => 0))
    when Gosu::Button::KbEscape then
      @window.enter_state MenuState.new(@window)
      @window.current_game_state.custom_message = 'Game paused!'
    when Gosu::Button::MsLeft then
      send_event(:mouse_left_down)
    end
  end

  def button_up(id)
    @buttons_down.delete id
  end

  def button_down?(id)
    @buttons_down.include? id
  end

  def update(dt)
    events = []

    controls = {
      :kb_left_down => [Gosu::Button::KbLeft, Gosu::Button::KbA],
      :kb_right_down => [Gosu::Button::KbRight, Gosu::Button::KbD],
      :kb_up_down => [Gosu::Button::KbUp, Gosu::Button::KbW],
      :kb_down_down => [Gosu::Button::KbDown, Gosu::Button::KbS],
    }
    controls.each_pair do |signal, keys|
      if keys.any? { |key| button_down? key }
          event = self.send(signal)
          event.options[:dt] = dt
          events << event
      end
    end

    return events
  end

  def kb_left_down
    Event.new(:move, :right_move => 0, :up_move => 0, :angle => -1, :timestamp => @state.timestamp, :simulation_time => @state.simulation_time)
  end
  def kb_right_down
    Event.new(:move, :right_move => 0, :up_move => 0, :angle => 1, :timestamp => @state.timestamp, :simulation_time => @state.simulation_time)
  end
  def kb_up_down
    Event.new(:move, :right_move => 0, :up_move => 1, :angle => 0, :timestamp => @state.timestamp, :simulation_time => @state.simulation_time)
  end
  def kb_down_down
    Event.new(:move, :right_move => 0, :up_move => -1, :angle => 0, :timestamp => @state.timestamp, :simulation_time => @state.simulation_time)
  end
end

