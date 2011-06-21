class SpacegameNetworkServer < NetworkServer
  def initialize(gamestate, options={})
    @gamestate = gamestate
    super(options)
  end
end
