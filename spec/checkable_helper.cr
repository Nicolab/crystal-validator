# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

# :ditto:
module H
  # Simple Test class.
  class CheckableSimpleTest
    # Mixin
    Check.checkable

    Check.rules(
      email: {
        check: {
          not_empty: {"Email should not be empty"},
          email:     {"It is not a valid email"},
        },
        clean: {
          type:   String,
          to:     :to_s,
          format: ->(email : String) { email.strip },
          # message: "Wrong type",
        },
      },
      age: {
        check: {
          min:     {"Age should be more than 18", 18},
          between: {"Age should be between 25 and 35", 25, 35},
        },
        clean: {type: Int32, to: :to_i32},
      }
    )

    property email : String
    property age : Int32?

    def initialize(@email, @age); end
  end

  # Test class.
  class CheckableTest
    # Mixin
    Check.checkable

    Check.rules(
      email: {
        check: {
          not_empty: {"Email should not be empty"},
          email:     {"It is not a valid email"},
        },
        clean: {
          type:    String,
          to:      :to_s,
          format:  ->self.format_email(String),
          message: "Wrong type",
        },
      },
      age: {
        check: {
          min:     {"Age should be more than 18", 18},
          between: {"Age should be between 25 and 35", 25, 35},
        },
        clean: {type: Int32, to: :to_i32, message: "Wrong type"},
      }
    )

    property email : String
    property age : Int32?

    # ---------------------------------------------------------------------------
    # Spied methods
    # ---------------------------------------------------------------------------

    property before_check_called : Bool = false
    property after_check_called : Bool = false
    property custom_checker_called : Bool = false
    property check_nothing_called : Bool = false

    @@before_check_called : Bool = false
    @@after_check_called : Bool = false
    @@custom_checker_called : Bool = false
    @@check_nothing_called : Bool = false

    # Reset spies of hooks
    def reset_hooks_state
      self.before_check_called = false
      self.after_check_called = false
      self.custom_checker_called = false
      self.check_nothing_called = false
    end

    # Reset spies of hooks
    def self.reset_hooks_state
      @@before_check_called = false
      @@after_check_called = false
      @@custom_checker_called = false
      @@check_nothing_called = false
    end

    def self.before_check_called
      @@before_check_called
    end

    def self.after_check_called
      @@after_check_called
    end

    def self.custom_checker_called
      @@custom_checker_called
    end

    def self.check_nothing_called
      @@check_nothing_called
    end

    # ---------------------------------------------------------------------------
    # Constructor
    # ---------------------------------------------------------------------------

    def initialize(@email, @age); end

    # ---------------------------------------------------------------------------
    # Lifecycle methods
    # ---------------------------------------------------------------------------

    def before_check(v, format)
      self.before_check_called = true
    end

    def after_check(v, format)
      self.after_check_called = true
    end

    def self.before_check(v, h, format)
      @@before_check_called = true
    end

    def self.after_check(v, h, cleaned_h, format)
      @@after_check_called = true
      cleaned_h
    end

    # ---------------------------------------------------------------------------
    #  Custom checkers
    # ---------------------------------------------------------------------------

    # Called by the instance.
    @[Check::Checker]
    def custom_checker(v, format)
      self.custom_checker_called = true
    end

    # Called statically.
    @[Check::Checker]
    def self.custom_checker(v, h, cleaned_h, format)
      @@custom_checker_called = true
      cleaned_h
    end

    # ---------------------------------------------------------------------------
    # Normal methods
    # ---------------------------------------------------------------------------

    # Called by the instance
    def check_nothing(v)
      self.check_nothing_called = true
    end

    # Called statically
    def self.check_nothing(v)
      @@check_nothing_called = true
    end

    # Format (convert) email.
    def self.format_email(email)
      email.strip
    end
  end

  # ----------------------------------------------------------------------------

  def self.should_hooks_be_called
    H::CheckableTest.after_check_called.should be_true
    H::CheckableTest.before_check_called.should be_true
    H::CheckableTest.custom_checker_called.should be_true
    H::CheckableTest.check_nothing_called.should be_false
  end

  def self.should_hooks_be_called(checkable)
    checkable.after_check_called.should be_true
    checkable.before_check_called.should be_true
    checkable.custom_checker_called.should be_true
    checkable.check_nothing_called.should be_false
  end

  def self.should_hooks_not_be_called
    H::CheckableTest.after_check_called.should be_false
    H::CheckableTest.before_check_called.should be_false
    H::CheckableTest.custom_checker_called.should be_false
    H::CheckableTest.check_nothing_called.should be_false
  end

  def self.should_hooks_not_be_called(checkable)
    checkable.after_check_called.should be_false
    checkable.before_check_called.should be_false
    checkable.custom_checker_called.should be_false
    checkable.check_nothing_called.should be_false
  end
end
