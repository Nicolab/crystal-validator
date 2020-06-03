module H
  class CheckableTest
    include Check::Checkable

    @[Check::Rules(email: {"It is not a valid email"})]
    property email : String
    @[Check::Rules(
      min: {"Age should be more than 18", 18},
      between: {"Age should be between 25 and 35", 25, 35},
    )]
    property age : Int32?

    property before_check_call : Bool = false
    property after_check_call : Bool = false
    property external_check_call : Bool = false
    property other_check_call : Bool = false

    def initialize(@email, @age)
    end

    def before_check(v)
      self.before_check_call = true
    end

    def after_check(v)
      self.after_check_call = true
    end

    @[Check::Checker]
    def external_check(v)
      self.external_check_call = true
    end

    def other_check(v)
      self.other_check_call = true
    end
  end
end
