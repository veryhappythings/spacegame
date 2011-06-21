require 'socket'

PACKET_HEADER_LENGTH = 4
PACKET_HEADER_FORMAT = "N"

class NetworkServer
  def initialize(options={})
    @ip = options[:ip] || "0.0.0.0"
    @port = options[:port] || 4444
    @socket = nil
    @sockets = []
    @max_read_per_update = options[:max_read_per_update] || 20000

    @packet_buffers = Hash.new
  end

  def start(ip=nil, port=nil)
    @ip = ip if ip
    @port = port if port
    begin
      @socket = TCPServer.new(@ip, @port)
      on_start
    rescue
      on_start_error($!)
    end

    return self
  end
  def on_start
    Utils.logger.info('Server Started')
  end
  def on_start_error(error)
    Utils.logger.info('Server Start error')
    p error
  end

  def update
    if @socket && !@socket.closed?
      handle_incoming_connections
      handle_incoming_data
    end
  end

  # Called when a client connects
  def on_connect(socket)
    Utils.logger.info("[Client Connected: #{socket}]")
  end

  # Called when a client disconnects
  def on_disconnect(socket)
    Utils.logger.info("[Client Disconnected: #{socket}]")
  end

  def handle_incoming_connections
    begin
      while socket = @socket.accept_nonblock
        @sockets << socket
        @packet_buffers[socket] = PacketBuffer.new
        on_connect(socket)
      end
    rescue IO::WaitReadable, Errno::EINTR
    end
  end

  def handle_incoming_data(max_size = @max_read_per_update)
    @sockets.each do |socket|
      if IO.select([socket], nil, nil, 0.0)
        begin
          packet, sender = socket.recvfrom(max_size)
          on_data(socket, packet)
        rescue Errno::ECONNABORTED, Errno::ECONNRESET
          @packet_buffers[socket] = nil

          on_disconnect(socket)
        end
      end
    end
  end

  # Called for each received data message
  def on_data(socket, data)
    buffer = @packet_buffers[socket]

    buffer.buffer_data data

    while packet = buffer.next_packet
      on_msg(socket, Marshal.load(packet))
    end
  end
  def on_msg(socket, msg)
    Utils.logger.info("received message: #{msg}")
  end

  def broadcast_msg(msg)
    data = Marshal.dump(msg)
    @sockets.each {|s| send_data(s, data) }
  end

  # Send message to socket
  def send_msg(socket, msg)
    send_data(socket, Marshal.dump(msg))
  end

  # Send raw 'data' to the 'socket'
  def send_data(socket, data)
    begin
      socket.write([data.length].pack(PACKET_HEADER_FORMAT))
      socket.write(data)
    rescue Errno::ECONNABORTED, Errno::ECONNRESET, Errno::EPIPE, Errno::ENOTCONN
      on_disconnect(socket)
    end
  end

  def disconnect_client(socket)
    socket.close
  end

  # Ensure that the buffer is cleared of data to write (call at the end of update or, at least after all sends).
  def flush
    @sockets.each {|s| s.flush }
  end

  # Stops server
  def stop
    return unless @socket
    begin
      @socket.close
    rescue Errno::ENOTCONN
    end
  end
end
