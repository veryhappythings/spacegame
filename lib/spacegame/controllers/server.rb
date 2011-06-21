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
    Utils.logger.info("Server received message: #{msg}")

    # Figure out what the socket represents
    #  - Assign player ID to socket on create message
    # Process message
    # Send out a response
  end
end
