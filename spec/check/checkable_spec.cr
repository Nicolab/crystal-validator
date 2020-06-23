# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Checkable" do
  Spec.before_each {
    H::CheckableTest.reset_hooks_state
  }

  describe "Simple checkable class without hooks" do
    context "check statically" do
      it "should check (valid)" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        h = {"email" => email, "age" => "30"}

        v, cleaned_h = H::CheckableSimpleTest.check(h)

        v.should be_a(Check::Validation)
        v.valid?.should be_true

        # Works by ref
        h.same? cleaned_h

        # Casted and formatted
        cleaned_h.should eq({"email" => "my@email.com", "age" => 30})
      end

      it "should check (invalid) with format" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        h = {"email" => email, "age" => "20"}

        v, cleaned_h = H::CheckableSimpleTest.check(h)

        v.should be_a(Check::Validation)
        v.valid?.should be_false
        v.errors.size.should eq 1
        v.errors.should eq({"age" => ["Age should be between 25 and 35"]})

        # Works by ref
        h.same? cleaned_h

        # Not valid but casted and formatted for handling data if needed
        cleaned_h.should eq({"email" => "my@email.com", "age" => 20})
      end

      it "should check (invalid) without format" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        h = {"email" => email, "age" => "20"}

        v, cleaned_h = H::CheckableSimpleTest.check(h, false)

        v.should be_a(Check::Validation)
        v.valid?.should be_false
        v.errors.size.should eq 2
        v.errors.should eq({
          "email" => ["It is not a valid email"],
          "age"   => ["Age should be between 25 and 35"],
        })

        # Works by ref
        h.same? cleaned_h

        # Not valid but casted and formatted for handling data if needed
        cleaned_h.should eq({"email" => " my@email.com ", "age" => 20})
      end
    end

    context "check on instance" do
      it "should check (valid) with format" do
        email = " my@email.com "
        age = 30

        checkable = H::CheckableSimpleTest.new email, age
        v = checkable.check

        v.should be_a(Check::Validation)
        v.valid?.should be_true

        # Formatted
        checkable.email.should eq email.strip
        checkable.age.should eq age
      end

      it "should check (invalid) with format" do
        email = " my@email.com "
        age = 20

        checkable = H::CheckableSimpleTest.new email, age
        v = checkable.check

        v.should be_a(Check::Validation)
        v.valid?.should be_false
        v.errors.size.should eq 1
        v.errors.should eq({"age" => ["Age should be between 25 and 35"]})

        # Not valid but formatted for handling data if needed
        checkable.email.should eq email.strip
        checkable.age.should eq age
      end

      it "should check (invalid) without format" do
        email = " my@email.com "
        age = 20

        checkable = H::CheckableSimpleTest.new email, age
        v = checkable.check false

        v.should be_a(Check::Validation)
        v.valid?.should be_false
        v.errors.size.should eq 2
        v.errors.should eq({
          "email" => ["It is not a valid email"],
          "age"   => ["Age should be between 25 and 35"],
        })

        # Not valid but formatted for handling data if needed
        checkable.email.should eq email
        checkable.age.should eq age
      end
    end
  end

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
        value.should eq(email.as_s.strip)
      end

      it "should only cast" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        ok, value = H::CheckableTest.clean_email(email, false)

        ok.should be_true
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
        v, value = H::CheckableTest.check_email(initial_v, email, true)

        initial_v.valid?.should be_true
        v.valid?.should be_true
        # test if object_id are identical
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # With explicit *format* `false` and invalid email (don't stripped)
        initial_v = Check.new_validation
        v, value = H::CheckableTest.check_email(initial_v, email, false)

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
        ok, value = checkable.class.clean_email(email, true)

        ok.should be_true
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # Test final state
        H.should_hooks_not_be_called(checkable)
      end

      it "should only cast" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        checkable = H::CheckableTest.new "", nil

        # Test initial state
        H.should_hooks_not_be_called(checkable)

        ok, value = checkable.class.clean_email(email, false)

        ok.should be_true
        value.class.should eq(String)
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
        v, value = checkable.class.check_email(initial_v, email, true)

        initial_v.valid?.should be_true
        v.valid?.should be_true
        # test if object_id are identical
        initial_v.same?(v)
        value.class.should eq(String)
        value.should eq(email.as_s.strip)

        # With explicit *format* `false` and invalid email (don't stripped)
        initial_v = Check.new_validation
        v, value = checkable.class.check_email(initial_v, email, false)

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

  describe "#check" do
    it "should call generated and custom checkers and lifecycle methods" do
      checkable = H::CheckableTest.new "wrong@mail", nil

      # Test initial state
      H.should_hooks_not_be_called(checkable)

      v = checkable.check

      v.should be_a(Check::Validation)
      v.valid?.should be_false
      # Custom error message defined in the email rule (CheckableTest)
      v.errors.should eq({"email" => ["It is not a valid email"]})

      # Lifecycle hooks
      H.should_hooks_be_called(checkable)
    end
  end

  describe ".check" do
    it "should check (valid) hash" do
      h = {
        "email" => "falsemail@mail.com ",
        "age"   => "30",
        "p"     => 'a',
        "c"     => H::CheckableTest.new("plop", nil),
      }

      # Test initial state
      H.should_hooks_not_be_called

      # Default *format* is `true'
      v, cleaned_h = H::CheckableTest.check h

      v.should be_a(Check::Validation)
      v.valid?.should be_true

      # Works by ref
      h.same? cleaned_h

      # Casted and formatted
      cleaned_h.should eq({"email" => "falsemail@mail.com", "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
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

      # *format* `false`
      v, cleaned_h = H::CheckableTest.check h, false

      v.should be_a(Check::Validation)
      v.valid?.should be_false
      # Custom error message defined in the email rule (CheckableTest)
      v.errors.should eq({"email" => ["It is not a valid email"]})

      # Works by ref
      h.same? cleaned_h

      # Casted but not formatted
      cleaned_h.should eq({"email" => "falsemail@mail.com ", "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
    end
  end
end
