# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "./spec_helper"

describe "Checkable" do
  Spec.before_each {
    H::CheckableTest.reset_hooks_state
  }

  describe "#check" do
    it "should call generated and custom checkers and lifecycle methods" do
      checkable = H::CheckableTest.new "wrong@mail", nil

      # Test initial state
      H.should_hooks_not_be_called(checkable)
      H.should_hooks_check_email_not_be_called

      v = checkable.check

      v.should be_a(Check::Validation)
      v.valid?.should be_false
      # Custom error message defined in the email rule (CheckableTest)
      v.errors.should eq({"email" => ["It is not a valid email"]})

      # Lifecycle hooks
      H.should_hooks_be_called(checkable)
      H.should_hooks_check_email_be_called
    end

    it "should call generated and custom checkers and lifecycle methods (check!)" do
      checkable = H::CheckableTest.new "wrong@mail", nil

      # Test initial state
      H.should_hooks_not_be_called(checkable)
      H.should_hooks_check_email_not_be_called

      ex = expect_raises(Check::ValidationError, "Validation error") do
        checkable.check!
      end

      # Custom error message defined in the email rule (CheckableTest)
      ex.errors.should eq({"email" => ["It is not a valid email"]})

      # Lifecycle hooks
      H.should_hooks_be_called(checkable)
      H.should_hooks_check_email_be_called
    end
  end

  describe ".check" do
    it "should check (valid) hash" do
      h = {
        "email"    => "falsemail@mail.com ",
        "username" => "john_doe",
        "age"      => "30",
        "p"        => 'a',
        "c"        => H::CheckableTest.new("plop", nil),
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # Default *format* is `true'
      v, cleaned_h = H::CheckableTest.check h

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # Casted and formatted
      cleaned_h.should eq({"email" => "falsemail@mail.com", "username" => "john_doe", "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should check (valid) hash (check!)" do
      h = {
        "email"    => "falsemail@mail.com ",
        "username" => "john_doe",
        "age"      => "30",
        "p"        => 'a',
        "c"        => H::CheckableTest.new("plop", nil),
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # Default *format* is `true'
      cleaned_h = H::CheckableTest.check! h

      # Works by ref
      h.same? cleaned_h

      # Casted and formatted
      cleaned_h.should eq({"email" => "falsemail@mail.com", "username" => "john_doe", "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should check (invalid) hash" do
      h = {
        "email" => "falsemail@mail.com ",
        "age"   => "30",
        "p"     => 'a',
        "c"     => H::CheckableTest.new("plop", nil),
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # *format* `false`
      ex = expect_raises(Check::ValidationError, "Validation error") do
        H::CheckableTest.check! h, format: false
      end

      # Custom error message defined in the email rule (CheckableTest)
      ex.errors.should eq({"email" => ["It is not a valid email"], "username" => ["Username is required"]})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end
  end
end
