class ServerState < State
  attr_accessor :objects
  def initialize
    @objects = []
  end

  def window
    nil
  end
end
