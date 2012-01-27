require 'spec_helper'

describe Weird do
  it 'should return correct version string' do
    Weird.version_string.should == "Weird version: #{Weird::VERSION}"
  end

  describe "#valid_ird?" do
    it "must be an integer" do
      Weird.valid_ird?("abc").should == false
    end
    it "should be greater than 10,000,000" do
      Weird.valid_ird?("10000000").should == false
    end
    it "should be less than 150,000,000" do
      Weird.valid_ird?("150000000").should == false
    end
  end

  describe "NZ IR scenarios" do
    # See http://www.ird.govt.nz/resources/c/5/c5a1198040c469449d4bbddaafba9fa8/payroll-spec-2011-v3.pdf page 73

    it "49091850 is valid" do
      Weird.valid_ird?("49091850").should == true
    end
    it "35901981 is valid" do
      Weird.valid_ird?("35901981").should == true
    end
    it "49098576 is valid" do
      Weird.valid_ird?("49098576").should == true
    end
    it "136410132 is valid" do
      Weird.valid_ird?("136410132").should == true
    end
    it "136410133 is invalid" do
      Weird.valid_ird?("136410133").should == false
    end
    it "9125568 is invalid" do
      Weird.valid_ird?("9125568").should == false
    end
  end
end