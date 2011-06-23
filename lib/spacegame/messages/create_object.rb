class CreateObject < Message
  def process(state)
    case self.klass
    when :player
      player = Player.new(state, self.x, self.y, self.angle)
      player.unique_id = self.unique_id
      if self.client_id == state.client_id
        state.player = player
        state.keyboard_controller.register(player)
      end
      state.scene_controller.register(player)
    when :bullet
      bullet = Bullet.new(state, self.x, self.y, self.angle)
      state.scene_controller.register(bullet)

      if state.is_a? ServerState
        state.server.broadcast_msg(bullet.to_msg(nil, self.timestamp))
      else
        bullet.unique_id = self.unique_id
      end
    else
      Utils.logger.warn("I don't know how to create #{self.klass}")
    end
  end
end
