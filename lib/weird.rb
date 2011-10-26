require 'weird/version'

module Weird
  FIRST_WEIGHTING  = [3, 2, 7, 6, 5, 4, 3, 2]
  SECOND_WEIGHTING = [7, 4, 3, 2, 5, 2, 7, 6]
  def self.version_string
    "Weird version #{Weird::VERSION}"
  end

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
  def self.valid_ird? input
    is_integer(input) && valid_range(input) && check_digit_matches(input)
  end

  private

  def self.is_integer input
    !!(input =~ /^[0-9]+$/)
  end

  def self.valid_range input
    10000000 < input.to_i && input.to_i < 150000000
  end

  def self.check_digit_matches input_array
    ird_array = convert_to_integer_array(input_array)
    provided_check_digit = ird_array.pop
    calculate_check_digit(ird_array) == provided_check_digit
  end

  def self.convert_to_integer_array input
    ird_array = input.split(//)
    ird_array.map!{ |x| x.to_i }
    if ird_array.size == 8
      ird_array.unshift(0)
    end
    ird_array
  end

  def self.calculate_check_digit input_array, weighting_array=FIRST_WEIGHTING
    remainder = calculate_remainder input_array, weighting_array
    return remainder if remainder == 0

    check_digit = 11 - remainder
    if check_digit == 10 && weighting_array == FIRST_WEIGHTING
      check_digit = calculate_check_digit input_array, SECOND_WEIGHTING
    end
    check_digit
  end

  def self.calculate_remainder input_array, weighting_array
    weighted_array = input_array.each_with_index.map { |x,i| x.to_i * weighting_array.at(i) }
    sum_of_weighted_array = weighted_array.inject{ |x,y| x+y }
    return sum_of_weighted_array.remainder(11)
  end
end