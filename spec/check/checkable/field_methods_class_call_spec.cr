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

  context "generated field methods: statically called on a class" do
    describe ".clean_{{field}}" do
      it "should cast and format" do
        email : JSON::Any = JSON::Any.new " my@email.com "

        # Implicit *format*: default is `true`
        ok, value = H::CheckableTest.clean_email(email)

        ok.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Explicit *format*
        ok, value = H::CheckableTest.clean_email(email, true)

        ok.should be_true
        value.class.should eq(String)
        value.should_not be_nil # not a union
        value.should eq(email.as_s.strip)
      end

      it "should cast and format (clean_{{field}}!)" do
        email : JSON::Any = JSON::Any.new " my@email.com "

        # Implicit *format*: default is `true`
        value = H::CheckableTest.clean_email!(email)

        value.class.should eq(String)
        value.should_not be_nil # not a union
        value.should eq(email.as_s.strip)

        # Explicit *format*
        value = H::CheckableTest.clean_email!(email, true)

        value.class.should eq(String)
        value.should_not be_nil # not a union
        value.should eq(email.as_s.strip)
      end

      it "should only cast" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        ok, value = H::CheckableTest.clean_email(email, false)

        ok.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s)
      end

      it "should only cast (clean_{{field}}!)" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        value = H::CheckableTest.clean_email!(email, false)

        value.class.should eq(String)
        value.should eq(email.as_s)
      end
    end

    describe ".check_{{field}}" do
      it "should success to check with the formatting of a malformed value" do
        email : JSON::Any = JSON::Any.new " my@email.com "

        # Implicit *format*: default is `true`
        v, value = H::CheckableTest.check_email(value: email)

        v.valid?.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Explicit *format*
        v, value = H::CheckableTest.check_email(value: email, format: true)

        v.valid?.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)
      end

      it "should success to check with the formatting of a malformed value (check_{{field}}!)" do
        email : JSON::Any = JSON::Any.new " my@email.com "

        # Implicit *format*: default is `true`
        value = H::CheckableTest.check_email!(value: email)

        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Explicit *format*
        value = H::CheckableTest.check_email!(value: email, format: true)

        value.class.should eq(String)
        value.should eq(email.as_s.strip)
      end

      it "should fail to check without formatting a malformed value" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        v, value = H::CheckableTest.check_email(value: email, format: false)

        v.valid?.should be_false
        value.class.should eq(String)
        value.should eq(email.as_s)
      end

      it "should work on the Validation instance (by ref) and return it" do
        email : JSON::Any = JSON::Any.new " my@email.com "

        # With explicit *format* `true`
        initial_v = Check.new_validation
        v, value = H::CheckableTest.check_email(initial_v, email, format: true)

        initial_v.valid?.should be_true
        v.valid?.should be_true
        # test if object_id are identical
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # With explicit *format* `false` and invalid email (don't stripped)
        initial_v = Check.new_validation
        v, value = H::CheckableTest.check_email(initial_v, email, format: false)

        initial_v.valid?.should be_false
        v.valid?.should be_false
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s)

        # With implicit *format* (default is `true`)
        # and invalid email (don't stripped)
        initial_v = Check.new_validation
        v, value = H::CheckableTest.check_email(initial_v, email)

        initial_v.valid?.should be_true
        v.valid?.should be_true
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s.strip)
      end
    end
  end
end
