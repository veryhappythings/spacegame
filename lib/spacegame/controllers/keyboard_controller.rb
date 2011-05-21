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
    # Actual controls - could use a refactor
    if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::KbA then
      event = Event.new(:kb_left_down, :dt => dt)
      @listeners.each do |l|
        l.handle_event(event)
      end
    end
    if button_down? Gosu::Button::KbRight or button_down? Gosu::Button::KbD then
      event = Event.new(:kb_right_down, :dt => dt)
      @listeners.each do |l|
        l.handle_event(event)
      end
    end
    if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::KbW then
      event = Event.new(:kb_up_down, :dt => dt)
      @listeners.each do |l|
        l.handle_event(event)
      end
    end
    if button_down? Gosu::Button::KbDown or button_down? Gosu::Button::KbS then
      event = Event.new(:kb_down_down, :dt => dt)
      @listeners.each do |l|
        l.handle_event(event)
      end
    end
  end
end

