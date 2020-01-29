# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  @@rx_number = /^([-+]?[0-9]*\.?[0-9]*)$/

  # Validates that the *value* is a numeric `String` representation.
  def self.number?(value : String) : Bool
    !value.blank? && !value.match(@@rx_number).nil?
  end
end
