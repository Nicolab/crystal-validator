# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  # Validates that the *value* is equal to *another_value*.
  def self.eq?(value, another_value) : Bool
    value == another_value
  end

  # Validates that the *value* is greater than *another_value*.
  def self.gt?(value, another_value) : Bool
    value > another_value
  end

  # Validates that the *value* is equal to or greater than *another_value*.
  # > Similar to `#min`.
  def self.gte?(value, another_value) : Bool
    value >= another_value
  end

  # Validates that the *value* is lesser than *another_value*.
  def self.lt?(value, another_value) : Bool
    value < another_value
  end

  # Validates that the *value* is equal to or lesser than *another_value*.
  # > Similar to `#max`.
  def self.lte?(value, another_value) : Bool
    value <= another_value
  end

  # Validates that the *value* is equal to or greater than *min* (inclusive).
  # > Similar to `#gte`.
  def self.min?(value, min) : Bool
    value >= min
  end

  # Validates that the *value* is equal to or lesser than *max* (inclusive).
  # > Similar to `#lte`.
  def self.max?(value, max) : Bool
    value <= max
  end

  # Validates that the *value* is between (inclusive) *min* and *max*.
  def self.between?(value, min, max) : Bool
    value >= min && value <= max
  end

  # Validates that the *value* is equal to the *size*.
  def self.size?(value, size : Int)
    value.size == size
  end

  # :ditto:
  def self.size?(value, size : String)
    value.size.to_s == size
  end

  # Validates that the *value* is in the *size* range.
  def self.size?(value, size : Range)
    size.includes?(value.size)
  end

  # Validates that the *value* is in the *size* array.
  def self.size?(value, size : Array(Int))
    size.includes?(value.size)
  end

  # :ditto:
  def self.size?(value, size : Array(String))
    size.includes?(value.size.to_s)
  end
end
