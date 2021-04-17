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

    property email : String
    property age : Int32?, {
      age: {
        check: {
          min:     {"Age should be more than 18", 18},
          between: {"Age should be between 25 and 35", 25, 35},
        },
        clean: {type: Int32, to: :to_i32, nilable: true},
      },
    }

    def initialize(@email, @age)
      init_props
    end

    Check.rules(
      email: {
        required: true,
        check:    {
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
    )
  end

  # Test class.
  class CheckableTest
    # Mixin
    Check.checkable

    Check.rules(
      email: {
        required:     true,
        before_check: :before_check_email,
        after_check:  ->(_v : Check::Validation, value : String?, _required : Bool, _format : Bool) {
          @@after_check_email_called = true
          value
        },
        check: {
          not_empty: {"Email should not be empty"},
          email:     {"It is not a valid email"},
        },
        clean: {
          type:    String,
          to:      :to_s,
          format:  :format_email,
          message: "Wrong type",
        },
      },
    )

    property email : String
    property username : String?, {
      username: {
        required: "Username is required",
        check:    {
          min: {"Length must be more than 2", 2},
        },
        clean: {type: String},
      },
    }
    property age : Int32?, {
      age: {
        check: {
          min:     {"Age should be more than 18", 18},
          between: {"Age should be between 25 and 35", 25, 35},
        },
        clean: {type: Int32, to: :to_i32, message: "Wrong type", nilable: true},
      },
    }

    # ---------------------------------------------------------------------------
    # Spied methods
    # ---------------------------------------------------------------------------

    property before_check_called : Bool = false
    property after_check_called : Bool = false
    property custom_checker_called : Bool = false
    property check_nothing_called : Bool = false

    @@before_check_called : Bool = false
    @@after_check_called : Bool = false
    @@before_check_email_called : Bool = false
    @@after_check_email_called : Bool = false
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
      @@before_check_email_called = false
      @@after_check_email_called = false
      @@custom_checker_called = false
      @@check_nothing_called = false
    end

    def self.before_check_called
      @@before_check_called
    end

    def self.after_check_called
      @@after_check_called
    end

    def self.before_check_email_called
      @@before_check_email_called
    end

    def self.after_check_email_called
      @@after_check_email_called
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

    private def before_check(v, required, format)
      self.before_check_called = true
    end

    private def after_check(v, required, format)
      self.after_check_called = true
    end

    private def self.before_check(v, h, required, format)
      @@before_check_called = true
    end

    private def self.after_check(v, h, cleaned_h, required, format)
      @@after_check_called = true
      cleaned_h
    end

    private def self.before_check_email(v, value, required, format)
      @@before_check_email_called = true
      value
    end

    # ---------------------------------------------------------------------------
    #  Custom checkers
    # ---------------------------------------------------------------------------

    # Called by the instance.
    @[Check::Checker]
    private def custom_checker(v, required, format)
      self.custom_checker_called = true
    end

    # Called statically.
    @[Check::Checker]
    private def self.custom_checker(v, h, cleaned_h, required, format)
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

  def self.should_hooks_be_called(klass : CheckableTest.class)
    klass.before_check_called.should be_true
    klass.after_check_called.should be_true
    klass.custom_checker_called.should be_true
    klass.check_nothing_called.should be_false
  end

  def self.should_hooks_be_called
    CheckableTest.before_check_called.should be_true
    CheckableTest.after_check_called.should be_true
    CheckableTest.custom_checker_called.should be_true
    CheckableTest.check_nothing_called.should be_false
  end

  def self.should_hooks_be_called(checkable : CheckableTest)
    checkable.before_check_called.should be_true
    checkable.after_check_called.should be_true
    checkable.custom_checker_called.should be_true
    checkable.check_nothing_called.should be_false
  end

  def self.should_hooks_not_be_called
    CheckableTest.before_check_called.should be_false
    CheckableTest.after_check_called.should be_false
    CheckableTest.custom_checker_called.should be_false
    CheckableTest.check_nothing_called.should be_false
  end

  def self.should_hooks_not_be_called(klass : CheckableTest.class)
    klass.before_check_called.should be_false
    klass.after_check_called.should be_false
    klass.custom_checker_called.should be_false
    klass.check_nothing_called.should be_false
  end

  def self.should_hooks_not_be_called(checkable : CheckableTest)
    checkable.before_check_called.should be_false
    checkable.after_check_called.should be_false
    checkable.custom_checker_called.should be_false
    checkable.check_nothing_called.should be_false
  end

  # ----------------------------------------------------------------------------

  def self.should_hooks_check_email_be_called
    self.should_before_check_email_be_called
    self.should_after_check_email_be_called
  end

  def self.should_hooks_check_email_not_be_called
    self.should_before_check_email_not_be_called
    self.should_after_check_email_not_be_called
  end

  def self.should_before_check_email_be_called
    CheckableTest.before_check_email_called.should be_true
  end

  def self.should_before_check_email_not_be_called
    CheckableTest.before_check_email_called.should be_false
  end

  def self.should_after_check_email_be_called
    CheckableTest.after_check_email_called.should be_true
  end

  def self.should_after_check_email_not_be_called
    CheckableTest.after_check_email_called.should be_false
  end
end
