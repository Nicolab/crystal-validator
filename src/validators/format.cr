# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  @@rx_time = /^(2[0-3]|[01]{1}[0-9]{1}):([0-5]{1}[0-9]{1}):([0-5]{1}[0-9]{1})$/

  # Regex based on https://github.com/validatorjs/validator.js/blob/master/src/lib/isJWT.js
  @@rx_jwt = /^([A-Za-z0-9\-_~+\/]+[=]{0,2})\.([A-Za-z0-9\-_~+\/]+[=]{0,2})(?:\.([A-Za-z0-9\-_~+\/]+[=]{0,2}))?$/

  @@rx_uuid = {
    # 0: all
    0 => /^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$/i,
    # versions
    3 => /^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$/i,
    4 => /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i,
    5 => /^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i,
  }

  # Hexadecimal
  @@rx_hex = /^(0x|0h)?[0-9A-F]+$/i
  @@rx_hex_color = /^#?([0-9A-F]{3}|[0-9A-F]{4}|[0-9A-F]{6}|[0-9A-F]{8})$/i

  @@rx_base64 = /^[a-zA-Z0-9+\/]+={0,2}$/
  @@rx_md5 = /^[a-f0-9]{32}$/

  # Validates that the *value* is a time `String` representation.
  def self.time?(value : String) : Bool
    !value.blank? && !value.match(@@rx_time).nil?
  end

  # ---------------------------------------------------------------------------
  # ascii_only?
  # ---------------------------------------------------------------------------

  # Validates that the *value* `String`
  # is comprised in its entirety by ASCII characters.
  def self.ascii_only?(value : String) : Bool
    value.ascii_only?
  end

  # Validates that all the `String` in the *values* `Array`
  # are comprised in their entirety by ASCII characters.
  def self.ascii_only?(values : Array(String)) : Bool
    size = value.size

    while size
      size -= 1
      return false unless value.ascii_only?(values[i])
    end

    true
  end

  # ------------------------------------------------------------------------- #

  # Validates that the *value* represents a JSON string.
  # *strict* to `true` (default) to try to parse the JSON,
  # returns `false if the parsing fails.
  # If *strict* is `false`, only the first char and the last char are checked.
  def self.json?(value : String, strict : Bool = true) : Bool
    if strict
      begin
        JSON.parse(value)
      rescue err
        return false
      else
        return true
      end
    end

    (self.starts?(value, "{") && self.ends?(value, "}")) ||
      (self.starts?(value, "[") && self.ends?(value, "]"))
  end

  # --------------------------------------------------------------------------#

  # Validates that the *value* has the format *md5*.
  def self.md5?(value : String) : Bool
    !value.match(@@rx_md5).nil?
  end

  # Validates that the *value* has the format *base64*.
  def self.base64?(value : String) : Bool
    return true if value.match(@@rx_base64) && (value.size % 4 === 0)
    return false
  end

  # --------------------------------------------------------------------------#

  # Validates that the *value* is a *JSON Web Token*.
  def self.jwt?(value : String) : Bool
    !value.match(@@rx_jwt).nil?
  end

  # --------------------------------------------------------------------------#

  # Validates that the *value* is a *UUID*
  # Versions: 0 (all), 3, 4 and 5. *version* by default is 0 (all).
  def self.uuid?(value : String, version = 0) : Bool
    return false unless @@rx_uuid.has_key?(version)
    !value.match(@@rx_uuid[version]).nil?
  end

  # --------------------------------------------------------------------------#

  # Validates that the `String` *value* does denote
  # a representation of a hexadecimal string.
  def self.hex?(value : String) : Bool
    !value.match(@@rx_hex).nil?
  end

  # Validates that the `Bytes` *value* does denote
  # a representation of a hexadecimal slice of Bytes.
  def self.hex?(value : Bytes) : Bool
    !String.new(value).match(@@rx_hex).nil?
  end

  # Validates that the `String` *value* does denote
  # a representation of a hexadecimal color.
  #
  # ```
  # Valid.hex_color? "#fff" => true
  # Valid.hex_color? "#ffffff" => true
  # ```
  def self.hex_color?(value : String) : Bool
    !value.match(@@rx_hex_color).nil?
  end

  # --------------------------------------------------------------------------#

  # Validates that the `String` *value* does denote
  # a representation of a *MongoID* string.
  def self.mongo_id?(value : String) : Bool
    self.hex?(value) && value.size == 24
  end

  # Validates that the `Bytes` *value* does denote
  # a representation of a *MongoID* slice of Bytes.
  def self.mongo_id?(value : Bytes) : Bool
    self.hex?(value) && value.size == 24
  end
end
