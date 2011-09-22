class Utils
  @@log = Logger.new(STDOUT)
  @@log.level = Logger::DEBUG
  def self.logger
    @@log
  end

  def self.degrees_to_radians(degrees)
    return degrees * Math::PI / 180
  end
end
