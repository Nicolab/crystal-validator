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

  context "generated field methods: statically called via instance" do
    describe "#class.clean_{{field}}" do
      it "should cast and format" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        # Implicit *format*: default is `true`
        ok, value = checkable.class.clean_email(email)

        ok.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Explicit *format*
        ok, value = checkable.class.clean_email(email, format: true)

        ok.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should cast and format (clean_{{field}}!)" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        # Implicit *format*: default is `true`
        value = checkable.class.clean_email!(email)

        value.class.should eq(String)
        value.class.should_not be_nil # not a union
        value.should eq(email.as_s.strip)

        # Explicit *format*
        value = checkable.class.clean_email!(email, format: true)

        value.class.should eq(String)
        value.class.should_not be_nil # not a union
        value.should eq(email.as_s.strip)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should only cast" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        ok, value = checkable.class.clean_email(email, format: false)

        ok.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should only cast (clean_{{field}}!)" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        value = checkable.class.clean_email!(email, format: false)

        value.class.should eq(String)
        value.class.should_not be_nil
        value.should eq(email.as_s)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end
    end

    describe "#class.check_{{field}}" do
      it "should success to check with the formatting of a malformed value" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        # Implicit *format*: default is `true`
        v, value = checkable.class.check_email(value: email)

        v.valid?.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Explicit *format*
        v, value = checkable.class.check_email(value: email, format: true)

        v.valid?.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should success to check with the formatting of a malformed value (check_{{field}}!)" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        # Implicit *format*: default is `true`
        value = checkable.class.check_email!(value: email)

        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Explicit *format*
        value = checkable.class.check_email!(value: email, format: true)

        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should fail to check without formatting a malformed value" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        v, value = checkable.class.check_email(value: email, format: false)

        v.valid?.should be_false
        value.class.should eq(String)
        value.should eq(email.as_s)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should work on the Validation instance (by ref) and return it" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        # With explicit *format* `true`
        initial_v = Check.new_validation
        v, value = checkable.class.check_email(initial_v, email, format: true)

        initial_v.valid?.should be_true
        v.valid?.should be_true
        # test if object_id are identical
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # With explicit *format* `false` and invalid email (don't stripped)
        initial_v = Check.new_validation
        v, value = checkable.class.check_email(initial_v, email, format: false)

        initial_v.valid?.should be_false
        v.valid?.should be_false
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s)

        # With implicit *format* (default is `true`)
        # and invalid email (don't stripped)
        initial_v = Check.new_validation
        v, value = checkable.class.check_email(initial_v, email)

        initial_v.valid?.should be_true
        v.valid?.should be_true
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end
    end
  end
end
