# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"
require "./checkable_bundle_class"

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

        v, cleaned_h = H::CheckableSimpleTest.check(h, format: false)

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
        v = checkable.check format: false

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
      v, cleaned_h = H::CheckableTest.check h, format: false

      v.should be_a(Check::Validation)
      v.valid?.should be_false
      # Custom error message defined in the email rule (CheckableTest)
      v.errors.should eq({"email" => ["It is not a valid email"], "username" => ["Username is required"]})

      # Works by ref
      h.same? cleaned_h

      # Casted but not formatted
      cleaned_h.should eq({"email" => "falsemail@mail.com ", "age" => 30})

      # Lifecycle hooks
      H.should_hooks_be_called
      H.should_hooks_check_email_be_called
    end
  end

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
  end

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
  end

  describe "#validation_rules" do
    it "should get validation rules" do
      H::BundleTest.test_validation_rules.should be_true
    end
  end

  describe "#validation_required?" do
    it "should returns true if the field is required" do
      H::BundleTest.test_validation_required_true.should be_true
    end

    it "should returns false if the field is not required" do
      H::BundleTest.test_validation_required_false.should be_true
    end
  end

  describe "#validation_nilable?" do
    it "should returns true if the field is nilable" do
      H::BundleTest.test_validation_nilable_true.should be_true
    end

    it "should returns false if the field is not nilable" do
      H::BundleTest.test_validation_nilable_false.should be_true
    end
  end

  describe "Converters Hash / JSON" do
    describe "#map_json_keys" do
      it "should get the map JSON keys" do
        map = H::BundleTest.map_json_keys
        map.should eq({"email" => "email", "age" => "age", "testCase" => "test_case"})
      end
    end

    describe "#to_crystal_h" do
      it "should get Crystal Hash (name convention) from JSON" do
        h = H::BundleTest.to_crystal_h(JSON.parse(%({"email": "false@mail.com", "age": 10, "testCase": null})).as_h)
        h.should eq({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
      end
    end

    describe "#to_json_h" do
      it "should get JSON Hash (name convention) from Crystal Hash" do
        h = H::BundleTest.to_json_h({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
        h.should eq(JSON.parse(%({"email": "false@mail.com", "age": 10, "testCase": null})).as_h)
      end
    end

    describe "#h_from_json" do
      it "should get Crystal Hash (name convention) from JSON string" do
        ok, h = H::BundleTest.h_from_json(%({"email": "false@mail.com", "age": 10, "testCase": null}))
        ok.should be_true
        h.should eq({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
      end

      it "should returns 'ok' false when JSON string is invalid (not converted to Hash)" do
        ok, h = H::BundleTest.h_from_json(%(email": "false@mail.com", "age": 10, "testCase": null}))
        ok.should be_false
        h.should be_nil
      end
    end
  end
end
