require File.dirname(__FILE__) + '/../spec_helper'

describe 'Playing with a local server' do
  before :each do
    @window = GameWindow.new
  end

  after :each do
    if server = @window.current_game_state.server
      server.stop
    end
    @window.close
  end

  it 'Should start a server when I start a game' do
    @window.current_game_state.select_item 'new game'
    @window.button_down(Gosu::Button::KbReturn)
    @window.current_game_state.class.should == PlayingState
    server = @window.current_game_state.server
    server.class.should == SpacegameNetworkServer
end

  context 'after starting the game' do
    before :each do
      @window = GameWindow.new
      @window.new_game!
      @server = @window.current_game_state.server
    end

    context 'after one update' do
      before :each do
        @window.update
      end

      specify 'the client should have created a player object' do
        @window.current_game_state.player.should_not == nil
      end
    end
  end
end
