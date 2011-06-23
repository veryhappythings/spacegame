class Message
  def initialize(options={})
    @options = options
  end

  def method_missing(sym, *args, &block)
    if @options.has_key? sym
      @options[sym]
    else
      super
    end
  end

  def respond_to?(sym)
    @options.has_key? sym || super(sym)
  end

  def name
    self.class.to_s.underscore.to_sym
  end

  def process(state)
  end
end
