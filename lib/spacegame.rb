ROOT = File.dirname(File.expand_path(__FILE__))

require 'rubygems'
require 'gosu'

require "#{ROOT}/spacegame/server"
require "#{ROOT}/spacegame/game_network_client"

require "#{ROOT}/spacegame/models/packet_buffer"
require "#{ROOT}/spacegame/models/state"

require "#{ROOT}/spacegame/views/game_window"

require "#{ROOT}/spacegame/controllers/states/menu_state"
require "#{ROOT}/spacegame/controllers/states/playing_state"
require "#{ROOT}/spacegame/controllers/keyboard_controller"
require "#{ROOT}/spacegame/controllers/scene_controller"
