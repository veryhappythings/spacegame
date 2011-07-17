class MenuState < State
  attr_accessor :window
  attr_accessor :custom_message

  attr_reader :menu_items, :current_item

  def initialize(window)
    super
    @window = window

    @custom_message = ''

    @font_size = 40
    @font = Gosu::Font.new(@window, Gosu::default_font_name, @font_size)

    @current_item = 0
    @menu_items = [
      'new game',
      'quit'
    ]

    if window.current_game_state.class == PlayingState
      @menu_items.insert(0, 'resume')
    end
  end

  def selected_item
    @menu_items[@current_item]
  end

  def select_item(item)
    @current_item = @menu_items.index item
    if @current_item == nil
      raise Exception.new, "Could not find item #{item}"
    end
    @current_item
  end

  def execute_action(action)
    case action
    when 'resume'
      @window.pop_state!
    when 'new game'
      @window.new_game!
    when 'quit'
      @window.close
    end
  end

  def button_down(id)
    case id
    when Gosu::Button::KbUp then
      if @current_item > 0
        @current_item -= 1
      end
    when Gosu::Button::KbDown then
      if @current_item < @menu_items.length - 1
        @current_item += 1
      end
    when Gosu::Button::KbReturn then
      execute_action(selected_item)
    end
  end

  def draw
    @font.draw(@custom_message, 20, 20, 0)

    y_offset = 50

    @menu_items.each_with_index do |item, i|
      @font.draw(item, @font_size*3, (i * @font_size) + y_offset, 0)
    end

    @font.draw('>', @font_size*2, (@current_item * @font_size) + y_offset+4, 0)
  end
end

