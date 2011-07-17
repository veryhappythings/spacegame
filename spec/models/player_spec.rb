require File.dirname(__FILE__) + '/../spec_helper'

describe Player do
  it 'should convert to a message' do
    state = ServerState.new
    player = Player.new(state, 0, 0, 0, '11111')

    msg = player.to_msg('client_id', '11111')
    msg.name.should == :create_object
    msg.klass.should == :player
  end
end

