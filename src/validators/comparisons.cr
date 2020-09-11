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

  # Validates that the size of the *value* (`String` or `Array`)
  # is greater than *limit* number.
  def self.gt?(value : String | Array, limit : Int) : Bool
    value.size > limit
  end

  # Validates that the *value* is equal to or greater than *another_value*.
  # > Similar to `#min`.
  def self.gte?(value, another_value) : Bool
    value >= another_value
  end

  # Validates that the size of the *value* (`String` or `Array`)
  # is greater than *min* number.
  # > Similar to `#min`.
  def self.gte?(value : String | Array, min : Int) : Bool
    value.size >= min
  end

  # Validates that the *value* is lesser than *another_value*.
  def self.lt?(value, another_value) : Bool
    value < another_value
  end

  # Validates that the size of the *value* (`String` or `Array`)
  # is lesser than *limit* number.
  def self.lt?(value : String | Array, limit : Int) : Bool
    value.size < limit
  end

  # Validates that the *value* is equal to or lesser than *another_value*.
  # > Similar to `#max`.
  def self.lte?(value, another_value) : Bool
    value <= another_value
  end

  # Validates that the size of the *value* (`String` or `Array`)
  # is equal or lesser than *max* number.
  # > Similar to `#max`.
  def self.lte?(value : String | Array, max : Int) : Bool
    value.size <= max
  end

  # Validates that the *value* is equal to or greater than *min* (inclusive).
  # > Similar to `#gte`.
  def self.min?(value, min) : Bool
    value >= min
  end

  # :ditto:
  # > Based on the size of the `String`.
  def self.min?(value : String | Array, min : Int) : Bool
    value.size >= min
  end

  # Validates that the *value* is equal to or lesser than *max* (inclusive).
  # > Similar to `#lte`.
  def self.max?(value, max) : Bool
    value <= max
  end

  # :ditto:
  # > Based on the size of the `String`.
  def self.max?(value : String | Array, max : Int) : Bool
    value.size <= max
  end

  # Validates that the *value* is between (inclusive) *min* and *max*.
  def self.between?(value, min, max) : Bool
    value >= min && value <= max
  end

  # Validates that the size of the *value* (`String` or `Array`) is between
  # (inclusive) *min* and *max*.
  # - See also `#size?`.
  def self.between?(value : String | Array, min : Int, max : Int) : Bool
    size = value.size
    size >= min && size <= max
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
  # - See also `#between?`.
  def self.size?(value, size : Range)
    size.includes?(value.size)
  end

  # Validates that the *value* is in the *size* array.
  # - See also `#between?`.
  def self.size?(value, size : Array(Int))
    size.includes?(value.size)
  end

  # :ditto:
  def self.size?(value, size : Array(String))
    size.includes?(value.size.to_s)
  end
end
