ROOT = File.dirname(File.expand_path(__FILE__))

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
require "#{ROOT}/spacegame/lib/string"

require "#{ROOT}/spacegame/lib/message"
require "#{ROOT}/spacegame/lib/point"
require "#{ROOT}/spacegame/lib/renderable"
require "#{ROOT}/spacegame/lib/state"
require "#{ROOT}/spacegame/lib/network_client"
require "#{ROOT}/spacegame/lib/network_server"

require "#{ROOT}/spacegame/models/packet_buffer"
require "#{ROOT}/spacegame/models/player"
require "#{ROOT}/spacegame/models/bullet"

require "#{ROOT}/spacegame/messages/connect"
require "#{ROOT}/spacegame/messages/create_object"
require "#{ROOT}/spacegame/messages/move"
require "#{ROOT}/spacegame/messages/warp"

require "#{ROOT}/spacegame/views/game_window"

require "#{ROOT}/spacegame/controllers/states/menu_state"
require "#{ROOT}/spacegame/controllers/states/playing_state"
require "#{ROOT}/spacegame/controllers/states/server_state"
require "#{ROOT}/spacegame/controllers/keyboard_controller"
require "#{ROOT}/spacegame/controllers/scene_controller"
require "#{ROOT}/spacegame/controllers/server"
require "#{ROOT}/spacegame/controllers/client"

