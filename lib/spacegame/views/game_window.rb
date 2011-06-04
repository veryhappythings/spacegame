class GameWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = "Spacegame"

    # Networking
    #client = GameNetworkClient.new
    #begin
    #  client.connect
    #rescue
    #  puts "No server connection"
    #end

    # State setup
    @state_stack = []
    @state_stack << MenuState.new(self)

    @current_time = Gosu::milliseconds
  end

  # State handling
  def current_game_state
    @state_stack.last
  end

  def enter_state(state)
    @state_stack << state
  end

  def pop_state!
    old_state = @state_stack.delete current_game_state
    if @state_stack.length == 0
      close
    end
    old_state
  end

  def in_game?
    @state_stack.find {|state| state.class == PlayingState}
  end

  def new_game!
    @state_stack = [
      MenuState.new(self),
      PlayingState.new(self)
    ]
  end

  # Game loop
  def button_down(id)
    current_game_state.button_down(id)
  end

  def button_up(id)
    current_game_state.button_up(id)
  end

  def update
    dt = (Gosu::milliseconds - @current_time) / 1000.0
    @current_time = Gosu::milliseconds

    current_game_state.update(dt)
  end

  def draw
    current_game_state.draw
  end
end
