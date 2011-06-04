class Event
  def initialize(name, options={})
    @name = name
    @options = options
    unless @options.has_key? :timestamp
      @options[:timestamp] = Time.now.to_i
    end
  end

  def to_s
    "#{@name}: #{@options.to_s}"
  end

  attr_reader :name
  attr_accessor :options
end

