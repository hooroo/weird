require 'weird/version'

module Weird
  FIRST_WEIGHTING  = [3, 2, 7, 6, 5, 4, 3, 2]
  SECOND_WEIGHTING = [7, 4, 3, 2, 5, 2, 7, 6]
  def self.version_string
    "Weird version: #{Weird::VERSION}"
  end

  # See http://www.ird.govt.nz/resources/c/5/c5a1198040c469449d4bbddaafba9fa8/payroll-spec-2011-v3.pdf for validation rules
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