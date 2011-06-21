class SpacegameNetworkServer < NetworkServer
  # Not yet sure how to attach sockets to particular players

  def initialize(gamestate, options={})
    @gamestate = gamestate
    super(options)
  end

  def on_connect(socket)
    super(socket)
  end

  def on_msg(socket, msg)
    super(socket, msg)
  end
end
