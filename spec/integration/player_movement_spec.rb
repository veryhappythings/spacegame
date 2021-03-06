require File.dirname(__FILE__) + '/../spec_helper'

describe 'Player Movement' do
  context 'When I am playing the game' do
    before :each do
      @window = GameWindow.new
      @window.new_game!
      @window.update
    end

    after :each do
      if server = @window.current_game_state.server_state.server
        server.stop
      end
      @window.close
    end


    it 'should allow me to move up by pressing W' do
      @window.current_game_state.scene_controller.player.y.should == 0
      @window.button_down(Gosu::Button::KbW)
      # Urgh. Messy. Think the velocity makes this take so long.
      @window.update
      @window.update
      @window.update
      @window.current_game_state.scene_controller.player.y.should < 0
    end
  end
end
