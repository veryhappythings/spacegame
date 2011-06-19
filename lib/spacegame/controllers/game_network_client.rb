require 'socket'

class GameNetworkClient
  def initialize(gamestate, options = {})
    @gamestate = gamestate
    @timeout = options[:timeout] || 4
    @ip = options[:ip] || "0.0.0.0"
    @port = options[:port] || 4444
    @max_read_per_update = options[:max_read_per_update] || 50000

    @socket = nil
    @connected = false
    @latency = 0
    @packet_counter = 0
    @packet_buffer = PacketBuffer.new
  end

  def connect(ip = nil, port = nil)
    return if @socket
    Utils.logger.info('Client Connecting...')

    @ip = ip      if ip
    @port = port  if port

    # Set up our @socket, update() will handle the actual nonblocking connection
    @socket = Socket.new(Socket::Constants::AF_INET, Socket::Constants::SOCK_STREAM, 0)
    @sockaddr = Socket.sockaddr_in(@port, @ip)

    return self
  end

  def on_connection_refused
    connect(@ip, @port)
  end
  def on_timeout
    connect(@ip, @port)
  end
  def on_connect
    Utils.logger.info("[Connected to Server #{@ip}:#{@port}]")
  end
  def on_disconnect
    Utils.logger.info("[Disconnected from Server]")
  end

  def update
    if @socket and not @connected
      begin
        # Start/Check on our nonblocking tcp connection
        @socket.connect_nonblock(@sockaddr)
      rescue Errno::EINPROGRESS   #rescue IO::WaitWritable
      rescue Errno::EALREADY
        if IO.select([@socket],nil,nil,0.1).nil?
          @socket = nil
          on_connection_refused
        end
      rescue Errno::EISCONN
        @connected = true
        on_connect
      rescue Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET
        on_connection_refused
      rescue Errno::ETIMEDOUT
        on_timeout
      end
    end

    handle_incoming_data
  end

  def handle_incoming_data(amount = @max_read_per_update)
    return unless @socket

    if IO.select([@socket], nil, nil, 0.0)
      begin
        packet, sender = @socket.recvfrom(amount)
        on_data(packet)
      rescue Errno::ECONNABORTED, Errno::ECONNRESET
        @connected = false
        @socket = nil
        on_disconnect
      end
    end
  end
  def on_data(data)
    @packet_buffer.buffer_data data

    while packet = @packet_buffer.next_packet
      on_msg(Marshal.load(packet))
    end
  end

  def on_msg(msg)
    Utils.logger.info("Received message: #{msg}")
  end

  def send_msg(msg)
    Utils.logger.info("Client sending message: #{msg}")
    send_data(Marshal.dump(msg))
  end

  def send_data(data)
    begin
      @socket.write([data.length].pack(PACKET_HEADER_FORMAT))
      @socket.write(data)
    rescue Errno::ECONNABORTED, Errno::ECONNRESET, Errno::EPIPE, Errno::ENOTCONN
      @connected = false
      @socket = nil
      on_disconnect
    end
  end

end

