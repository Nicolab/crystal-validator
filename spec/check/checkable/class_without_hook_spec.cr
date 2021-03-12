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

      it "should check! (valid)" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        h = {"email" => email, "age" => "30"}

        cleaned_h = H::CheckableSimpleTest.check!(h)

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

      it "should check! (invalid) with format" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        h = {"email" => email, "age" => "20"}

        ex = expect_raises(Check::ValidationError, "Validation error") do
          H::CheckableSimpleTest.check!(h)
        end

        ex.errors.size.should eq 1
        ex.errors.should eq({"age" => ["Age should be between 25 and 35"]})
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

      it "should check! (invalid) without format" do
        email : JSON::Any = JSON::Any.new " my@email.com "
        h = {"email" => email, "age" => "20"}

        ex = expect_raises(Check::ValidationError, "Validation error") do
          H::CheckableSimpleTest.check!(h, format: false)
        end

        ex.errors.size.should eq 2
        ex.errors.should eq({
          "email" => ["It is not a valid email"],
          "age"   => ["Age should be between 25 and 35"],
        })
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

      it "should check! (valid) with format" do
        email = " my@email.com "
        age = 30

        checkable = H::CheckableSimpleTest.new email, age
        checkable.check!.should be checkable

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

      it "should check! (invalid) with format" do
        email = " my@email.com "
        age = 20

        checkable = H::CheckableSimpleTest.new email, age

        ex = expect_raises(Check::ValidationError, "Validation error") do
          checkable.check!
        end

        ex.errors.size.should eq 1
        ex.errors.should eq({"age" => ["Age should be between 25 and 35"]})

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

      it "should check! (invalid) without format" do
        email = " my@email.com "
        age = 20

        checkable = H::CheckableSimpleTest.new email, age
        ex = expect_raises(Check::ValidationError, "Validation error") do
          checkable.check! format: false
        end

        ex.errors.size.should eq 2
        ex.errors.should eq({
          "email" => ["It is not a valid email"],
          "age"   => ["Age should be between 25 and 35"],
        })

        # Not valid but formatted for handling data if needed
        checkable.email.should eq email
        checkable.age.should eq age
      end
    end
  end
end
