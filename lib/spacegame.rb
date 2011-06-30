require 'rubygems'
require 'gosu'
require 'logger'
require 'json'

class Utils
  @@log = Logger.new(STDOUT)
  @@log.level = Logger::DEBUG
  def self.logger
    @@log
  end
end

# Monkeypatches
require_relative "spacegame/lib/string"

require_relative "spacegame/lib/message"
require_relative "spacegame/lib/point"
require_relative "spacegame/lib/renderable"
require_relative "spacegame/lib/state"
require_relative "spacegame/lib/network_client"
require_relative "spacegame/lib/network_server"

require_relative "spacegame/models/packet_buffer"
require_relative "spacegame/models/player"
require_relative "spacegame/models/bullet"
require_relative "spacegame/models/block"
require_relative "spacegame/models/space_tile"

require_relative "spacegame/messages/connect"
require_relative "spacegame/messages/create_object"
require_relative "spacegame/messages/move"
require_relative "spacegame/messages/warp"
require_relative "spacegame/messages/destroy"

require_relative "spacegame/views/game_window"

require_relative "spacegame/controllers/states/menu_state"
require_relative "spacegame/controllers/states/playing_state"
require_relative "spacegame/controllers/states/server_state"
require_relative "spacegame/controllers/keyboard_controller"
require_relative "spacegame/controllers/scene_controller"
require_relative "spacegame/controllers/server"
require_relative "spacegame/controllers/client"

