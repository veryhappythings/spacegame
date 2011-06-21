
class SpacegameNetworkClient < NetworkClient
  def initialize(gamestate, options = {})
    @gamestate = gamestate
    super(options)
  end

  def on_msg(msg)
    super(msg)
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

