class SpacegameNetworkClient < NetworkClient
  def initialize(state, options = {})
    @state = state
    super(options)
  end

  # Receive incoming messages from the server
  def on_msg(msg)
    @state.handle_msg(msg)
  end
end

