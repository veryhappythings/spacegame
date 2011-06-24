class Destroy < Message
  def process(state)
    state.scene_controller.deregister(state.scene_controller.find(self.unique_id))
  end
end
