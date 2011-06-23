class Warp < Message
  def process(state)
    if object = state.scene_controller.find(self.unique_id)
      object.warp(self.x, self.y, self.angle)
    end
  end
end
