class CreateObject < Message
  def process(state)
    case self.klass
    when :player
      player = Player.new(state, self.x, self.y, self.angle, self.client_id)
      if state.is_a? PlayingState # Client only code
        player.unique_id = self.unique_id
        if self.client_id == state.client_id
          # Respawn case
          if state.player
            state.keyboard_controller.deregister(state.player)
            # Should always be a redundant call, but might as well double-check
            state.scene_controller.deregister(state.player)
          end

          state.player = player
          state.keyboard_controller.register(player)
        end
      end

      if state.is_a? ServerState
        state.server.broadcast_msg(player.to_msg(self.client_id, self.timestamp))
      end

      state.scene_controller.register(player)
    when :bullet
      # Clients and servers both do this
      bullet = Bullet.new(state, self.x, self.y, self.angle, self.creator)
      state.scene_controller.register(bullet)

      if state.is_a? ServerState
        state.server.broadcast_msg(bullet.to_msg(nil, self.timestamp))
      else
        bullet.unique_id = self.unique_id
      end
    when :block
      block = Block.new(state, self.x, self.y)
      block.unique_id = self.unique_id
      state.scene_controller.register(block)
    when :spacejunk
      junk = Spacejunk.new(state, self.x, self.y)
      junk.unique_id = self.unique_id
      state.scene_controller.register(junk)
    when :enemy
      enemy = Enemy.new(state, self.x, self.y, self.angle)
      enemy.unique_id = self.unique_id
      state.scene_controller.register(enemy)
    else
      Utils.logger.warn("I don't know how to create #{self.klass}")
    end
  end
end
