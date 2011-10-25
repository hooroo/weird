require 'spec_helper'

describe Weird do
  it 'should return correct version string' do
    Weird.version_string.should == "Weird version #{Weird::VERSION}"
  end
end