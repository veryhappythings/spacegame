require File.dirname(__FILE__) + '/../spec_helper'

describe 'Menu' do
  context 'When I am on the opening menu' do
    before :each do
      @window = GameWindow.new
    end
    it 'should allow me to start a game' do
      @window.current_game_state.select_item 'new game'
      @window.button_down(Gosu::Button::KbReturn)
      @window.current_game_state.class.should == PlayingState
    end
  end

  context 'When I am in a game, on the menu' do
#        Scenario: Resume the game
#                Given that I am playing a game
#                And I have brought up the menu
#                And I have selected "resume"
#                When I press "Return"
#                Then I should be playing the game
    before :each do
      @window = GameWindow.new
      @window.new_game!
      @window.button_down(Gosu::Button::KbEscape)
    end

    it 'should allow me to resume' do
      @window.current_game_state.select_item 'resume'
      @window.button_down(Gosu::Button::KbReturn)
      @window.current_game_state.class.should == PlayingState
    end
  end
end
