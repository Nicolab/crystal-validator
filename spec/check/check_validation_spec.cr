# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Check" do
  it "Check::Errors" do
    Check::Errors.new.is_a?(Hash).should be_true
  end

  describe "ValidationError" do
    it "should create Exception taking Errors container" do
      v = Check.new_validation
      v.add_error "my_field", "Oops"

      ex = Check::ValidationError.new v.errors
      ex.should be_a Check::ValidationError
      ex.should be_a Exception
      ex.errors.should be_a Check::Errors
      ex.errors.size.should eq 1
      ex.errors["my_field"].should eq ["Oops"]
      ex.message.should eq "Validation error"
    end

    it "should support custom message, pluralize it if ends with error" do
      v = Check.new_validation
      v.add_error "my_field", "Oops"

      ex = Check::ValidationError.new v.errors
      ex.errors.size.should eq 1
      ex.message.should eq "Validation error"

      v.add_error "my_field2", "Oops"
      ex = Check::ValidationError.new v.errors
      ex.errors.size.should eq 2
      ex.message.should eq "Validation errors"

      ex = Check::ValidationError.new v.errors, "Bad validation"
      ex.errors.size.should eq 2
      ex.message.should eq "Bad validation"
    end
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

    it "#to_exception" do
      v = Check.new_validation
      v.add_error "my_field", "Oops"

      ex = v.to_exception
      ex.should be_a Check::ValidationError
      ex.should be_a Exception
      ex.errors.should be_a Check::Errors
      ex.errors.size.should eq 1
      ex.errors["my_field"].should eq ["Oops"]
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
end
