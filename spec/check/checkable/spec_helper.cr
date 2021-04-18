# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../../spec_helper"
require "./checkable_helper"

module H
  # Test class.
  @[JSON::Serializable::Options(emit_nulls: true)]
  class BundleTest
    # Mixin
    Check.checkable

    Check.rules(
      age: {
        check: {
          min:     {"Age should be more than 18", 18},
          between: {"Age should be between 25 and 35", 25, 35},
        },
        clean: {type: Int32, to: :to_i32, nilable: true},
      }
    )

    property email : String, {
      required: true,
      check:    {
        not_empty: {"Email should not be empty"},
        email:     {"It is not a valid email"},
      },
      clean: {
        type: String,
        to:   :to_s,
      },
    }

    property age : Int32?

    @[JSON::Field(key: "testCase")]
    property test_case : Bool?

    def initialize(@email, @age)
      init_props
    end

    def self.test_validation_rules
      self.validation_rules["email"]["required"].should be_true
      self.validation_rules["age"]["clean"].should_not be_empty
      true
    end

    def self.test_validation_required_true
      self.validation_required?("email").should be_true
      true
    end

    def self.test_validation_required_false
      self.validation_required?("age").should be_false
      true
    end

    def self.test_validation_nilable_true
      self.validation_nilable?("age").should be_true
      true
    end

    def self.test_validation_nilable_false
      self.validation_nilable?("email").should be_false
      true
    end
  end
end
