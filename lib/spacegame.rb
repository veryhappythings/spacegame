require 'rubygems'
require 'gosu'
require 'logger'
require 'json'

ROOT = File.dirname(File.expand_path(__FILE__))
require "#{ROOT}/spacegame/lib/require_all"
require "#{ROOT}/spacegame/lib/utils"

require_all "#{ROOT}/spacegame/lib"
require_all "#{ROOT}/spacegame/models"
require_all "#{ROOT}/spacegame/messages"
require_all "#{ROOT}/spacegame/views"
require_all "#{ROOT}/spacegame/controllers"
