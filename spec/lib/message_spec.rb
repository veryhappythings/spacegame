require File.dirname(__FILE__) + '/../spec_helper'

describe Message do
  it 'should allow access to anything passed in at init' do
    msg = Message.new(:jam => :player, :shoes => :toast)

    msg.jam.should == :player
    msg.shoes.should == :toast
  end

  it 'should have a lowercase, symbolised name' do
    Message.new.name.should == :message
  end
end
