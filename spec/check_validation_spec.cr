# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "./spec_helper"

describe "Check" do
  it "Check::Errors" do
    Check::Errors.new.is_a?(Hash).should be_true
  end

  it "#new_validation" do
    v = Check.new_validation
    v.class.should eq Check::Validation
    v.errors.class.should eq Check::Errors
  end

  it "#new_validation(errors : Errors)" do
    errors = Check::Errors.new
    errors[:custom] = ["custom error"]

    v = Check.new_validation(errors)
    v.class.should eq Check::Validation
    v.errors.class.should eq Check::Errors

    errors.should eq v.errors
    v.errors.size.should eq 1
    v.errors[:custom].should eq ["custom error"]
  end

  describe "Validation" do
    it "#initialize" do
      v = Check::Validation.new
      v.errors.class.should eq Check::Errors
    end

    it "#initialize(errors : Errors)" do
      errors = Check::Errors.new
      errors[:custom] = ["custom error"]

      v = Check::Validation.new errors
      v.class.should eq Check::Validation
      v.errors.class.should eq Check::Errors

      errors.should eq v.errors

      v.errors.size.should eq 1
      v.errors[:custom].should eq ["custom error"]
    end

    it "#errors" do
      v = Check.new_validation
      v.errors.class.should eq Check::Errors
      v.errors.is_a?(Hash).should be_true
    end

    it "#add_error" do
      v = Check.new_validation

      v.add_error :with_message, "my message"
      v.errors[:with_message].should eq ["my message"]

      v.add_error :with_message, "my message2"
      v.errors[:with_message].should eq ["my message", "my message2"]

      v.add_error :without_message, ""
      v.errors[:without_message].should eq ["\"without_message\" is not valid."]

      v.add_error :without_message, ""
      v.errors[:without_message].should eq [
        "\"without_message\" is not valid.",
        "\"without_message\" is not valid.",
      ]

      v.errors.to_a.should eq [
        {
          :with_message,
          ["my message", "my message2"],
        },
        {
          :without_message, [
            "\"without_message\" is not valid.",
            "\"without_message\" is not valid.",
          ],
        },
      ]
    end

    it "#valid?" do
      v = Check.new_validation

      v.check(:ok, is(:eq?, 1, 1))
      v.valid?.should be_true

      v.check(:ok, is(:eq?, 0, 1))
      v.valid?.should be_false
    end

    it "#check with string and symbol keys" do
      v = Check.new_validation

      v.check("ok", is(:eq?, 1, 1))
      v.valid?.should be_true

      v.check(:ok, is(:eq?, 1, 1))
      v.valid?.should be_true

      v.check("ko", is(:eq?, 0, 1))
      v.valid?.should be_false

      v.check(:ko, is(:eq?, 0, 1))
      v.valid?.should be_false

      v.errors["ko"].should eq [
        "\"ko\" is not valid.",
      ]

      v.errors[:ko].should eq [
        "\"ko\" is not valid.",
      ]

      v.errors.to_a.should eq [
        {"ko", ["\"ko\" is not valid."]},
        {:ko, ["\"ko\" is not valid."]},
      ]
    end

    context "check overloads" do
      it "#check(key : Symbol, message : String, valid : Bool)" do
        v = Check.new_validation

        v.check(:a, "my A message", is :eq?, 1, 1)
        v.check(:b, "my B message", is :eq?, 1, 1)
        v.check(:empty_msg, "", is :eq?, 1, 1)

        v.valid?.should be_true

        v # chain test
          .check(:a, "my A message", is :eq?, 1, 0)
          .check(:b, "my B message", is :eq?, 1, 1)
          .check(:empty_msg, "", is :eq?, 1, 1)

        v.valid?.should be_false
        v.errors.size.should eq 1

        v.errors[:a].should eq ["my A message"]

        v.errors.clear

        v.valid?.should be_true
        v.errors.size.should eq 0

        v.check(:a, "my A message", is :eq?, 1, 0)
        v.check(:b, "my B message", is :eq?, 1, 0)
        v.check(:empty_msg, "", is :eq?, 1, 0)

        v.check(:a, "my A message 2", is :eq?, 1, 0)
        v.check(:b, "my B message 2", is :eq?, 1, 0)
        v.check(:empty_msg, "", is :eq?, 1, 0)

        v.errors.to_a.should eq [
          {
            :a,
            ["my A message", "my A message 2"],
          },
          {
            :b,
            ["my B message", "my B message 2"],
          },
          {
            :empty_msg, [
              "\"empty_msg\" is not valid.",
              "\"empty_msg\" is not valid.",
            ],
          },
        ]
      end

      it "#check(key : Symbol, valid : Bool, message : String)" do
        v = Check.new_validation

        v.check(:a, is(:eq?, 1, 1), "my A message")
        v.check(:b, is(:eq?, 1, 1), "my B message")
        v.check(:empty_msg, is(:eq?, 1, 1), "")

        v.valid?.should be_true

        v # chain test
          .check(:a, is(:eq?, 1, 0), "my A message")
          .check(:b, is(:eq?, 1, 1), "my B message")
          .check(:empty_msg, is(:eq?, 1, 1), "")

        v.valid?.should be_false
        v.errors.size.should eq 1

        v.errors[:a].should eq ["my A message"]

        v.errors.clear

        v.valid?.should be_true
        v.errors.size.should eq 0

        v.check(:a, is(:eq?, 1, 0), "my A message")
        v.check(:b, is(:eq?, 1, 0), "my B message")
        v.check(:empty_msg, is(:eq?, 1, 0), "")

        v.check(:a, is(:eq?, 1, 0), "my A message 2")
        v.check(:b, is(:eq?, 1, 0), "my B message 2")
        v.check(:empty_msg, is(:eq?, 1, 0), "")

        v.errors.to_a.should eq [
          {
            :a,
            ["my A message", "my A message 2"],
          },
          {
            :b,
            ["my B message", "my B message 2"],
          },
          {
            :empty_msg, [
              "\"empty_msg\" is not valid.",
              "\"empty_msg\" is not valid.",
            ],
          },
        ]
      end

      it "#check(key : Symbol, valid : Bool)" do
        v = Check.new_validation

        v.check(:a, is :eq?, 1, 1)
        v.check(:b, is :eq?, 1, 1)

        v.valid?.should be_true

        v # chain test
          .check(:a, is :eq?, 1, 0)
          .check(:b, is :eq?, 1, 1)

        v.valid?.should be_false
        v.errors.size.should eq 1

        v.errors[:a].should eq ["\"a\" is not valid."]

        v.errors.clear

        v.valid?.should be_true
        v.errors.size.should eq 0

        v.check(:a, is :eq?, 1, 0)
        v.check(:b, is :eq?, 1, 0)

        v.check(:a, is :eq?, 1, 0)
        v.check(:b, is :eq?, 1, 0)

        v.errors.to_a.should eq [
          {
            :a, [
              "\"a\" is not valid.",
              "\"a\" is not valid.",
            ],
          },
          {
            :b, [
              "\"b\" is not valid.",
              "\"b\" is not valid.",
            ],
          },
        ]
      end
    end
  end

  describe "::Checkable" do
    context "generated field methods" do
      context "clean" do
        it "should cast and format" do
          email : JSON::Any = JSON::Any.new " my@email.com "
          ok, value = H::CheckableTest.clean_email(email)

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

      context "check" do
        it "should success check with format" do
          email : JSON::Any = JSON::Any.new " my@email.com "
          v, value = H::CheckableTest.check_email(value: email)

          v.valid?.should be_true
          value.class.should eq(String)
          value.should eq(email.as_s.strip)
        end

        it "should fail to check without format" do
          email : JSON::Any = JSON::Any.new " my@email.com "
          v, value = H::CheckableTest.check_email(value: email, format: false)

          v.valid?.should be_false
          value.class.should eq(String)
          value.should eq(email.as_s)
        end
      end
    end

    context "on instance" do
      it "should call field and generic checkers and lifecycle methods" do
        checker_test = H::CheckableTest.new "wrong@mail", nil
        v = checker_test.check

        v.should be_a(Check::Validation)
        checker_test.after_check_called.should be_true
        checker_test.before_check_called.should be_true
        checker_test.external_check_called.should be_true
        checker_test.other_check_called.should be_false

        v.errors.should eq({"email" => ["It is not a valid email"]})
      end
    end

    context "on class" do
      it "should check hash" do
        h = {"email" => "falsemail@mail.com ", "age" => "30", "p" => 'a', "c" => H::CheckableTest.new("plop", nil)}
        v, cleaned_h = H::CheckableTest.check h

        v.should be_a(Check::Validation)
        H::CheckableTest.after_check_called.should be_true
        H::CheckableTest.before_check_called.should be_true
        H::CheckableTest.external_check_called.should be_true
        H::CheckableTest.other_check_called.should be_false

        v.valid?.should be_true
        cleaned_h.should eq({"email" => "falsemail@mail.com", "age" => 30})
      end
    end
  end
end
