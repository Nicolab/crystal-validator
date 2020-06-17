module H
  class CheckableTest
    Check.checkable

    property email : String
    property age : Int32?

    Check.rules(
      email: {
        check: {
          not_empty: {"Email should not be empty"},
          email:     {"It is not a valid email"},
        },
        clean: {type: String, to: :to_s, format: ->self.convert_email(String), message: "Wrong type"},
      },
      age: {
        check: {
          min:     {"Age should be more than 18", 18},
          between: {"Age should be between 25 and 35", 25, 35},
        },
        clean: {type: Int32, to: :to_i32, message: "Wrong type"},
      }
    )

    #---------------------------------------------------------------------------
    # Spied methods
    #---------------------------------------------------------------------------
    property before_check_called : Bool = false
    property after_check_called : Bool = false
    property external_check_called : Bool = false
    property other_check_called : Bool = false
    @@before_check_called : Bool = false
    @@after_check_called : Bool = false
    @@external_check_called : Bool = false
    @@other_check_called : Bool = false

    def self.before_check_called
      @@before_check_called
    end

    def self.after_check_called
      @@after_check_called
    end

    def self.external_check_called
      @@external_check_called
    end

    def self.other_check_called
      @@other_check_called
    end

    #---------------------------------------------------------------------------
    # Constructor
    #---------------------------------------------------------------------------

    def initialize(@email, @age)
    end

    #---------------------------------------------------------------------------
    # Lifecycle methods
    #---------------------------------------------------------------------------

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

    #---------------------------------------------------------------------------
    #  Custom checkers
    #---------------------------------------------------------------------------

    @[Check::Checker]
    def external_check(v, format)
      self.external_check_called = true
    end

    @[Check::Checker]
    def self.external_check(v, h, cleaned_h, format)
      @@external_check_called = true
      cleaned_h
    end

    #---------------------------------------------------------------------------
    # Normal methods
    #---------------------------------------------------------------------------

    def other_check(v)
      self.other_check_called = true
    end

    def self.other_check(v)
      @@other_check_called = true
    end

    def self.convert_email(email)
      email.strip
    end
  end
end
