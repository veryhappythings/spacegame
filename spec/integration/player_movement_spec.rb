require File.dirname(__FILE__) + '/../spec_helper'

describe 'Player Movement' do
  context 'When I am playing the game' do
    before :each do
      @window = GameWindow.new
      @window.new_game!
    end

    it 'should allow me to move up by pressing W' do
      @window.button_down(Gosu::Button::KbW)
      @window.update
      @window.current_game_state.scene_controller.player.y.should < 300
    end
  end
end
