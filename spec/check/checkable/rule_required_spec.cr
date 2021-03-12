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

  describe "rule: required" do
    it "should not check a class type not nilable and not supplied in a Hash with required: false" do
      h = {
        "age" => "30",
        "p"   => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # *required* `false`
      v, cleaned_h = H::CheckableTest.check h, required: false

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # Casted and cleaned
      cleaned_h.should eq({"age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end

    it "should not check a class type not nilable and not supplied in a Hash \
    with required: false (check!)" do
      h = {
        "age" => "30",
        "p"   => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # *required* `false`
      cleaned_h = H::CheckableTest.check! h, required: false

      # Works by ref
      h.same? cleaned_h

      # Casted and cleaned
      cleaned_h.should eq({"age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end

    it "should check and not populate a class field not supplied in a Hash with required: true" do
      h = {
        "age" => "30",
        "p"   => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # *required* `true` (explicit)
      v, cleaned_h = H::CheckableTest.check h, required: true

      v.should be_a(Check::Validation)
      v.valid?.should be_false

      # Default email message and
      # custom required message defined in the username rule (CheckableTest)
      v.errors.should eq({
        "email"    => ["This field is required"],
        "username" => ["Username is required"],
      })

      # Works by ref
      h.same? cleaned_h

      # Casted and cleaned
      cleaned_h.should eq({"age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end

    it "should check if a key is present and \
    do not add error if its value is nil and field nilable" do
      h = {
        "email"    => "false@mail.com",
        "username" => nil,
        "age"      => "30",
        "p"        => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # *required* `true` (explicit)
      v, cleaned_h = H::CheckableTest.check h, required: true

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # Casted and cleaned
      cleaned_h.should eq({"email" => "false@mail.com", "username" => nil, "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should check if a key is present and \
    do not add error if its value is nil and field nilable (check!)" do
      h = {
        "email"    => "false@mail.com",
        "username" => nil,
        "age"      => "30",
        "p"        => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      # *required* `true` (explicit)
      cleaned_h = H::CheckableTest.check! h, required: true

      # Works by ref
      h.same? cleaned_h

      # Casted and cleaned
      cleaned_h.should eq({"email" => "false@mail.com", "username" => nil, "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should not populate a field (age) if not provided in a Hash with required: true" do
      h = {
        # should be formatted
        "email"    => "false@mail.com ",
        "username" => nil,
        "p"        => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      v, cleaned_h = H::CheckableTest.check h, required: true

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed
      cleaned_h.should eq({"email" => "false@mail.com", "username" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should not populate a field (age) if not provided in a Hash with required: true (check!)" do
      h = {
        # should be formatted
        "email"    => "false@mail.com ",
        "username" => nil,
        "p"        => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      cleaned_h = H::CheckableTest.check! h, required: true

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed
      cleaned_h.should eq({"email" => "false@mail.com", "username" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should not populate the fields if not provided in a Hash with required: false" do
      h = {
        "p" => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      v, cleaned_h = H::CheckableTest.check h, required: false

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed and other are preserved
      cleaned_h.size.should eq(0)

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end

    it "should not populate the fields if not provided in a Hash with required: false (check!)" do
      h = {
        "p" => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      cleaned_h = H::CheckableTest.check! h, required: false

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed and other are preserved
      cleaned_h.size.should eq(0)

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end
  end
end
