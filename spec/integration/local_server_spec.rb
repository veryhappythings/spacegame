require File.dirname(__FILE__) + '/../spec_helper'

describe 'Playing with a local server' do
  before :each do
    @window = GameWindow.new
  end

  after :each do
    @window.close
  end

  it 'Should start a server when I start a game' do
    @window.current_game_state.select_item 'new game'
    @window.button_down(Gosu::Button::KbReturn)
    @window.current_game_state.class.should == PlayingState
    server = @window.current_game_state.server
    server.class.should == LocalServer
  end

  context 'just after starting the game' do
    before :each do
      @window.new_game!
      @server = @window.current_game_state.server
      @received_event = @server.received_events[0]
    end

    specify 'the client should have sent the server a connect event' do
      @server.class.should == LocalServer
      @received_event.name.should == :connect
    end

    specify 'the server should have issued a create object event' do
      @server.events[0].name.should == :create_object
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
