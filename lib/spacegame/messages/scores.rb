class Scores < Message
  def process(state)
    state.scores = self.scores
  end
end
