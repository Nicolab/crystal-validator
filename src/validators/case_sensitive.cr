# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  # Validates that the *value* is in lower case.
  def self.lower?(value : String) : Bool
    !value.blank? && value.downcase === value
  end

  # Validates that the *value* is in upper case.
  def self.upper?(value : String) : Bool
    !value.blank? && value.upcase === value
  end
end
