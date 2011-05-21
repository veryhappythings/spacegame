class GameWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = "Spacegame"

    client = GameNetworkClient.new
    begin
      client.connect
    rescue
      puts "No server connection"
    end
  end
end
