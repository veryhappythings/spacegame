class Event
  def initialize(name, options={})
    @name = name
    @options = options
  end
  attr_reader :name, :options
end

