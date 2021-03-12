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

  describe "clean: nilable option" do
    it "should preserve nilable field (age) when it is nil required: false" do
      h = {
        "age" => nil,
        "p"   => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      v, cleaned_h = H::CheckableTest.check h, required: false

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed
      cleaned_h.should eq({"age" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end

    it "should preserve nilable field (age) when it is nil required: false (check!)" do
      h = {
        "age" => nil,
        "p"   => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      cleaned_h = H::CheckableTest.check! h, required: false

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed
      cleaned_h.should eq({"age" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_not_be_called
    end

    it "should preserve nilable field (age, username) and other when it is nil required: true" do
      h = {
        # should be formatted
        "email"    => " false@mail.com ",
        "username" => nil,
        "age"      => nil,
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

      # hash fields not in the rules are removed and other are preserved
      cleaned_h.should eq({"email" => "false@mail.com", "username" => nil, "age" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should preserve nilable field (age, username) and other when it is nil required: true (check!)" do
      h = {
        # should be formatted
        "email"    => " false@mail.com ",
        "username" => nil,
        "age"      => nil,
        "p"        => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      cleaned_h = H::CheckableTest.check! h, required: true

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed and other are preserved
      cleaned_h.should eq({"email" => "false@mail.com", "username" => nil, "age" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should preserve nilable field (age) and other when it is nil required: false" do
      h = {
        # should be formatted
        "email" => " false@mail.com ",
        "age"   => nil,
        "p"     => 'a',
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
      cleaned_h.should eq({"email" => "false@mail.com", "age" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end

    it "should preserve nilable field (age) and other when it is nil required: false (check!)" do
      h = {
        # should be formatted
        "email" => " false@mail.com ",
        "age"   => nil,
        "p"     => 'a',
      }

      # Test initial state
      H.should_hooks_not_be_called
      H.should_hooks_check_email_not_be_called

      cleaned_h = H::CheckableTest.check! h, required: false

      # Works by ref
      h.same? cleaned_h

      # hash fields not in the rules are removed and other are preserved
      cleaned_h.should eq({"email" => "false@mail.com", "age" => nil})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end
  end
end
