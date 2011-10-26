require 'spec_helper'

describe Weird do
  it 'should return correct version string' do
    Weird.version_string.should == "Weird version #{Weird::VERSION}"
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
    # see http://www.ird.govt.nz/resources/f/7/f713cb8044511c2d89629934ed236b23/draft-payroll-spec-2012-v1.01.pdf

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
    # IR number 49091850. The base number is 49091850 and the supplied check digit is 0. The
    # number is greater than 10,000,000. Using the weightings above:
    # (0*3) + 4*2) + (9*7) + (0*6) + (9*5) + (1*4) + (8*3) + (5*2) = 154.
    # 154 / 11 = 14 remainder 0 (i.e. mod(154,11) = 0)
    # The remainder (0) = check digit (0), so no further calculation is necessary

  # Check digit validation
  # The following steps are to be performed:
  # - Valid range >10,000,000 & <150,000,000 (This will ensure invalid numbers that will not
  # be issued for another 10 years cannot be used in error)
  # - To each of the base number’s eight digits a weight factor is assigned.  From left to right
  # these are: 3, 2, 7, 6, 5, 4, 3, 2.
  # - Where the base number is seven digits remember there is a leading zero.
  # - Sum together the products of the weight factors and their associated digits.
  # - Divide the sum by 11. If the remainder is 0 then the check digit is 0.
  # - If the remainder is not 0 then subtract this number from 11, giving the check digit (0 - 9
  # are valid).
  # - If the resulting check digit is 10, use a secondary set of weight factors and apply steps 2
  # and 3 to the same input base number.  From left to right the factors for an eight digit
  # base number are: 7, 4, 3, 2, 5, 2, 7, 6.
  # - Remember there is a leading zero for a seven digit base number.  If the new check digit
  # is again 10 then the IRD number is invalid (0 - 9 is valid).
  # - Compare the calculated check digit with the check digit on the IRD number.  If they
  # match then the IRD number is valid.