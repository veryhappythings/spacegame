
class SpacegameNetworkClient < NetworkClient
  def initialize(gamestate, options = {})
    @gamestate = gamestate
    super(options)
  end
end

