class Connect < Message
  def process(state, socket)
    if state.server.clients.has_key? self.client_id
      Utils.logger.error("SERVER: client with ID #{self.client_id} already exists!")
    end

    state.server.clients[self.client_id] = self.timestamp
    player = Player.new(state, 0, 0, 0, self.client_id)
    state.scene_controller.register(player)

    state.scores[self.client_id] = {
      :kills => 0,
      :deaths => 0
    }

    state.server.broadcast_msg(player.to_msg(self.client_id, self.timestamp))
    state.scene_controller.objects.each do |object|
      unless object == player
        state.server.send_msg(socket, object.to_msg(nil, self.timestamp))
      end
    end

    state.server.send_msg(socket, Scores.new(
      :scores => state.scores,
      :timestamp => @timestamp
    ))
  end
end
