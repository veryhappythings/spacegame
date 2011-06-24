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
      @state.client.send_msg(CreateObject.new(
        :klass => :bullet,
        :x => @state.player.x,
        :y => @state.player.y,
        :angle => @state.player.angle,
        :timestamp => @state.timestamp,
        :creator => @state.player.unique_id,
      ))
    when Gosu::Button::KbEscape then
      @window.enter_state MenuState.new(@window)
      @window.current_game_state.custom_message = 'Game paused!'
    end
  end

  def button_up(id)
    @buttons_down.delete id
  end

  def button_down?(id)
    @buttons_down.include? id
  end

  def update(dt)
    msgs = []

    controls = {
      :kb_left_down => [Gosu::Button::KbLeft, Gosu::Button::KbA],
      :kb_right_down => [Gosu::Button::KbRight, Gosu::Button::KbD],
      :kb_up_down => [Gosu::Button::KbUp, Gosu::Button::KbW],
      :kb_down_down => [Gosu::Button::KbDown, Gosu::Button::KbS],
    }
    controls.each_pair do |signal, keys|
      if keys.any? { |key| button_down? key }
          msg = self.send(signal, dt)
          msgs << msg
      end
    end

    return msgs
  end

  def kb_left_down(dt)
    Move.new(
      :right_move => 0,
      :up_move => 0,
      :angle => -1,
      :timestamp => @state.timestamp,
      :unique_id => @state.player.unique_id,
      :simulation_time => @state.simulation_time,
      :dt => dt
    )
  end
  def kb_right_down(dt)
    Move.new(
      :right_move => 0,
      :up_move => 0,
      :angle => 1,
      :timestamp => @state.timestamp,
      :unique_id => @state.player.unique_id,
      :simulation_time => @state.simulation_time,
      :dt => dt
    )
  end
  def kb_up_down(dt)
    Move.new(
      :right_move => 0,
      :up_move => 1,
      :angle => 0,
      :timestamp => @state.timestamp,
      :unique_id => @state.player.unique_id,
      :simulation_time => @state.simulation_time,
      :dt => dt
    )
  end
  def kb_down_down(dt)
    Move.new(
      :right_move => 0,
      :up_move => -1,
      :angle => 0,
      :timestamp => @state.timestamp,
      :unique_id => @state.player.unique_id,
      :simulation_time => @state.simulation_time,
      :dt => dt
    )
  end
end

