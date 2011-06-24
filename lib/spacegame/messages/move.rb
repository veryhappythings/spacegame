class Move < Message
  def process(state, simulation_time)
    player = state.scene_controller.find(self.unique_id)
    if player
      up_move = self.up_move
      angle = self.angle
      # Only up_move is used because left/right is controlled by angle
      #x_movement = Gosu::offset_x(player.angle + angle, Player::SPEED * up_move) * simulation_time
      #y_movement = Gosu::offset_y(player.angle + angle, Player::SPEED * up_move) * simulation_time
      #player.warp(player.x + x_movement, player.y + y_movement, player.angle + angle)
      player.velocity += up_move
      player.angle += angle
      state.scene_controller.mark_as_dirty(player)
    end
  end
end
