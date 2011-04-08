# From Chingu
#
class PacketBuffer
  def initialize
    @data = '' # Buffered data.
    @length = nil # Length of the next packet. nil if header not read yet.
  end

  # Add data string to the buffer.
  def buffer_data(data)
    @data << data
  end

  # Call after adding data with #buffer_data until there are no more packets left.
  def next_packet
    # Read the header to find out the length of the next packet.
    unless @length
      if @data.length >= PACKET_HEADER_LENGTH
        @length = @data[0...PACKET_HEADER_LENGTH].unpack(PACKET_HEADER_FORMAT)[0]
        @data[0...PACKET_HEADER_LENGTH] = ''
      end
    end

    # If there is enough data after the header for the full packet, return it.
    if @length and @length <= @data.length
      begin
        packet =  @data[0...@length]
        @data[0...@length] = ''
        @length = nil
        return packet
      rescue TypeError => ex
        puts "Bad data received:\n#{@data.inspect}"
        raise ex
      end
    else
      return nil
    end
  end
end

