# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  # Validates that the *value* matches the *pattern*.
  def self.match?(value : String, pattern : Regex) : Bool
    !value.match(pattern).nil?
  end

  # :ditto:
  def self.match?(value : Number, pattern : Regex) : Bool
    !value.to_s.match(pattern).nil?
  end

  # ---------------------------------------------------------------------------
  # presence?
  # ---------------------------------------------------------------------------

  # Validates the presence of the value.
  # - See also `#in?`.
  # - See also `#not_empty?`.
  def self.presence?(key : String | Symbol | Number, list : Hash) : Bool
    self.not_empty?(list[key]?)
  end

  # :ditto:
  def self.presence?(key : String | Symbol, list : NamedTuple) : Bool
    self.not_empty?(list[key]?)
  end

  # ---------------------------------------------------------------------------
  # absence?
  # ---------------------------------------------------------------------------

  # Validates the absence of the value.
  # - See also `#not_in?`.
  # - See also `#empty?`.
  def self.absence?(key : String | Symbol | Number, list : Hash) : Bool
    self.empty?(list[key]?)
  end

  # :ditto:
  def self.absence?(key : String | Symbol, list : NamedTuple) : Bool
    self.empty?(list[key]?)
  end

  # ---------------------------------------------------------------------------
  # empty? / not_empty?
  # ---------------------------------------------------------------------------

  # Validates that the *value* is empty.
  # - See also `#absence?`.
  # - See also `#not_in?`.
  def self.empty?(value) : Bool
    case value
    when .nil?                then true
    when .is_a?(String)       then value.presence.nil?
    when .is_a?(Number)       then value == 0
    when .responds_to?(:size) then value.size == 0
    else                           false
    end
  end

  # Validates that the *value* is not empty.
  # - See also `#presence?`.
  # - See also `#in?`.
  def self.not_empty?(value) : Bool
    self.empty?(value) == false
  end

  # ---------------------------------------------------------------------------
  # null? / not_null?
  # ---------------------------------------------------------------------------

  # Validates that the *value* is null (`nil`).
  # - See also `#empty?`.
  # - See also `#not_null?`.
  def self.null?(value) : Bool
    value.nil?
  end

  # Validates that the *value* is not null (`nil`).
  # - See also `#null?`.
  # - See also `#not_empty?`.
  def self.not_null?(value) : Bool
    !value.nil?
  end

  # ---------------------------------------------------------------------------
  # in?
  # ---------------------------------------------------------------------------

  # Validates that the (*str*) `String` contains the *value*.
  # - See also `#presence?`.
  # - See also `#not_in?`.
  # - See also `#not_empty?`.
  def self.in?(value : String, str : String) : Bool
    str.includes?(value)
  end

  # Validates that the (*list*) contains the *value*.
  # - See also `#presence?`.
  # - See also `#not_in?`.
  # - See also `#not_empty?`.
  def self.in?(value, list : Array) : Bool
    list.includes?(value)
  end

  # :ditto:
  def self.in?(value, list : Tuple) : Bool
    list.includes?(value)
  end

  # :ditto:
  def self.in?(value, list : Range) : Bool
    list.includes?(value)
  end

  # :ditto:
  def self.in?(key : Symbol | String, list : NamedTuple) : Bool
    list.has_key? key
  end

  # :ditto:
  def self.in?(key : Symbol | String, list : Hash) : Bool
    list.has_key? key
  end

  # ---------------------------------------------------------------------------
  # not_in?
  # ---------------------------------------------------------------------------

  # Validates that the (*str*) `String` does not contain the *value*.
  # - See also `#absence?`.
  # - See also `#in?`.
  # - See also `#empty?`.
  def self.not_in?(value : String, str : String) : Bool
    !str.includes?(value)
  end

  # Validates that the (*list*) does not contain the *value*.
  # - See also `#absence?`.
  # - See also `#in?`.
  # - See also `#empty?`.
  def self.not_in?(value, list : Array) : Bool
    !list.includes?(value)
  end

  # :ditto:
  def self.not_in?(value, list : Tuple) : Bool
    !list.includes?(value)
  end

  # :ditto:
  def self.not_in?(value, list : Range) : Bool
    !list.includes?(value)
  end

  # :ditto:
  def self.not_in?(key : Symbol | String, list : NamedTuple) : Bool
    !list.has_key? key
  end

  # :ditto:
  def self.not_in?(key : Symbol | String, list : Hash) : Bool
    !list.has_key? key
  end

  # ---------------------------------------------------------------------------
  # Accepted
  # ---------------------------------------------------------------------------

  # Validates that the *value* `String` is the representation of an acceptance.
  # > One of: "yes", "y", "on", "o", "ok", "1", "true"
  # - See also `#refused?`.
  def self.accepted?(value : String) : Bool
    self.in? value.downcase, ["yes", "y", "on", "o", "ok", "1", "true"]
  end

  # Validates that the *value* is the representation of an acceptance.
  # > One of: "yes", "y", "on", "o", "ok", "1", "true"
  #
  # *value* must implements *#to_s* method.
  # - See also `#refused?`.
  def self.accepted?(value) : Bool
    self.accepted? value.to_s
  end

  # ---------------------------------------------------------------------------
  # Refused
  # ---------------------------------------------------------------------------

  # Validates that the *value* `String` is the representation of a refusal.
  # > One of: "no", "n", "off", "0", "false"
  # - See also `#accepted?`.
  def self.refused?(value : String) : Bool
    self.in? value.downcase, ["no", "n", "off", "0", "false"]
  end

  # Returns `true` if the *value* is the representation of a refusal.
  # > One of: "no", "n", "off", "0", "false"
  #
  # *value* must implements *#to_s* method.
  # - See also `#accepted?`.
  def self.refused?(value) : Bool
    self.refused? value.to_s
  end

  # ---------------------------------------------------------------------------
  # Starts with
  # ---------------------------------------------------------------------------

  # Validates that the `String` *value* starts with *search*.
  # - See also `#ends?`.
  # - See also `#match?`.
  # - See also `#in?`.
  def self.starts?(value : String, search : String) : Bool
    value.starts_with? search
  end

  # :ditto:
  def self.starts?(value : String, search : Char) : Bool
    value.starts_with? search
  end

  # :ditto:
  def self.starts?(value : String, search : Regex) : Bool
    value.starts_with? search
  end

  # ---------------------------------------------------------------------------
  # Ends with
  # ---------------------------------------------------------------------------

  # Validates that the `String` *value* ends with *search*.
  # - See also `#starts?`.
  # - See also `#match?`.
  # - See also `#in?`.
  def self.ends?(value : String, search : String) : Bool
    value.ends_with? search
  end

  # :ditto:
  def self.ends?(value : String, search : Char) : Bool
    value.ends_with? search
  end

  # :ditto:
  def self.ends?(value : String, search : Regex) : Bool
    value.ends_with? search
  end
end
