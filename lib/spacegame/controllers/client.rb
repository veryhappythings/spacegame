
class SpacegameNetworkClient < NetworkClient
  def initialize(state, options = {})
    @state = state
    super(options)
  end

  # Receive incoming messages from the server
  def on_msg(msg)
    @state.handle_event(msg)
  end

  def send_msg(msg)
    super(msg)
  end

  def on_connect
    super
  end

  def on_disconnect
    super
  end
end

