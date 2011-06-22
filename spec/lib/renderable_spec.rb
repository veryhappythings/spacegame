require File.dirname(__FILE__) + '/../spec_helper'

describe Renderable do
  it 'should always get a unique ID' do
    r1 = Renderable.new
    r1.unique_id.should == 1
    r2 = Renderable.new
    r2.unique_id.should == 2
  end

  it 'should have a unique ID even when inherited from' do
    class SubRenderable < Renderable
    end

    r1 = Renderable.new
    r1.unique_id.should == 3

    r2 = SubRenderable.new
    r2.unique_id.should == 4
  end
end
