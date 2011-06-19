class Event
  def initialize(name, options={})
    @name = name
    @options = options
    unless @options.has_key? :timestamp
      @options[:timestamp] = (Time.now.to_f * 100000).to_i
    end
  end

  def to_s
    "#{@name}: #{@options.to_s}"
  end

  #def marshal_dump
  #  Marshal.dump({:name => @name}.merge(@options).to_json)
  #end

  #def marshal_load str
  #  puts 'marshal_load'
  #  puts str
  #  details = JSON.parse str
  #  @name = details[:name]
  #  @options = details
  #end

  attr_reader :name
  attr_accessor :options
end

