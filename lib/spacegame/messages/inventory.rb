class Inventory < Message
  def process(state)
    state.player.inventory = self.inventory
  end
end
