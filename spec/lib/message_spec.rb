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

  it 'should have an underscored name when the name is camelcase' do
    class TestMessage < Message
    end

    TestMessage.new.name.should == :test_message
  end
end
