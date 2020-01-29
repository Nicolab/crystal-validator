# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#match?" do
  it "should return true if it matches" do
    Valid.match?(42, /^[0-9]+$/).should be_true
    is(:match?, 42, /^[0-9]+$/).should be_true
    is!(:match?, 42, /^[0-9]+$/).should be_true

    Valid.match?("42", /^[0-9]+$/).should be_true
    is(:match?, "42", /^[0-9]+$/).should be_true
    is!(:match?, "42", /^[0-9]+$/).should be_true
  end

  it "should return false if it not matches" do
    Valid.match?("a", /^[0-9]+$/).should be_false
    is(:match?, "a", /^[0-9]+$/).should be_false
    is_error :match? { is!(:match?, "a", /^[0-9]+$/) }
  end
end

describe "Valid#presence?" do
  context "Hash" do
    list = get_hash

    it "should return true if present" do
      Valid.presence?(:one, list).should be_true
      is(:presence?, :one, list).should be_true
      is!(:presence?, :one, list).should be_true

      Valid.presence?(:false, list).should be_true
      is(:presence?, :false, list).should be_true
      is!(:presence?, :false, list).should be_true

      Valid.presence?("present", list).should be_true
      is(:presence?, "present", list).should be_true
      is!(:presence?, "present", list).should be_true
    end

    it "should return false if not present" do
      Valid.presence?(:zero, list).should be_false
      is(:presence?, :zero, list).should be_false
      is_error :presence? { is!(:presence?, :zero, list) }

      Valid.presence?(:nil, list).should be_false
      is(:presence?, :nil, list).should be_false
      is_error :presence? { is!(:presence?, :nil, list) }

      Valid.presence?("nil", list).should be_false
      is(:presence?, "nil", list).should be_false
      is_error :presence? { is!(:presence?, "nil", list) }

      Valid.presence?(:blank_str, list).should be_false
      is(:presence?, :blank_str, list).should be_false
      is_error :presence? { is!(:presence?, :blank_str, list) }

      Valid.presence?(:space, list).should be_false
      is(:presence?, :space, list).should be_false
      is_error :presence? { is!(:presence?, :space, list) }

      Valid.presence?(:empty_array, list).should be_false
      is(:presence?, :empty_array, list).should be_false
      is_error :presence? { is!(:presence?, :empty_array, list) }

      Valid.presence?("absent", list).should be_false
      is(:presence?, "absent", list).should be_false
      is_error :presence? { is!(:presence?, "absent", list) }
    end
  end

  context "NamedTuple" do
    list = get_named_tuple

    it "should return true if present" do
      Valid.presence?(:one, list).should be_true
      is(:presence?, :one, list).should be_true
      is!(:presence?, :one, list).should be_true

      Valid.presence?(:false, list).should be_true
      is(:presence?, :false, list).should be_true
      is!(:presence?, :false, list).should be_true

      Valid.presence?(:present, list).should be_true
      is(:presence?, :present, list).should be_true
      is!(:presence?, :present, list).should be_true

      Valid.presence?("present", list).should be_true
      is(:presence?, "present", list).should be_true
      is!(:presence?, "present", list).should be_true

      Valid.presence?(:int32_array, list).should be_true
      is(:presence?, :int32_array, list).should be_true
      is!(:presence?, :int32_array, list).should be_true
    end

    it "should return false if not present" do
      Valid.presence?(:zero, list).should be_false
      is(:presence?, :zero, list).should be_false
      is_error :presence? { is!(:presence?, :zero, list) }

      Valid.presence?(:nil, list).should be_false
      is(:presence?, :nil, list).should be_false
      is_error :presence? { is!(:presence?, :nil, list) }

      Valid.presence?(:blank_str, list).should be_false
      is(:presence?, :blank_str, list).should be_false
      is_error :presence? { is!(:presence?, :blank_str, list) }

      Valid.presence?(:space, list).should be_false
      is(:presence?, :space, list).should be_false
      is_error :presence? { is!(:presence?, :space, list) }

      Valid.presence?(:empty_array, list).should be_false
      is(:presence?, :empty_array, list).should be_false
      is_error :presence? { is!(:presence?, :empty_array, list) }

      Valid.presence?("empty_array", list).should be_false
      is(:presence?, "empty_array", list).should be_false
      is_error :presence? { is!(:presence?, "empty_array", list) }

      Valid.presence?(:absent, list).should be_false
      is(:presence?, :absent, list).should be_false
      is_error :presence? { is!(:presence?, :absent, list) }

      Valid.presence?("absent", list).should be_false
      is(:presence?, "absent", list).should be_false
      is_error :presence? { is!(:presence?, "absent", list) }
    end
  end
end

describe "Valid#absence?" do
  context "Hash" do
    list = get_hash

    it "should return true if absent" do
      Valid.absence?(:zero, list).should be_true
      is(:absence?, :zero, list).should be_true
      is!(:absence?, :zero, list).should be_true

      Valid.absence?(:nil, list).should be_true
      is(:absence?, :nil, list).should be_true
      is!(:absence?, :nil, list).should be_true

      Valid.absence?("nil", list).should be_true
      is(:absence?, "nil", list).should be_true
      is!(:absence?, "nil", list).should be_true

      Valid.absence?(:blank_str, list).should be_true
      is(:absence?, :blank_str, list).should be_true
      is!(:absence?, :blank_str, list).should be_true

      Valid.absence?(:space, list).should be_true
      is(:absence?, :space, list).should be_true
      is!(:absence?, :space, list).should be_true

      Valid.absence?(:empty_array, list).should be_true
      is(:absence?, :empty_array, list).should be_true
      is!(:absence?, :empty_array, list).should be_true

      Valid.absence?("absent", list).should be_true
      is(:absence?, "absent", list).should be_true
      is!(:absence?, "absent", list).should be_true
    end

    it "should return false if not absent" do
      Valid.absence?(:one, list).should be_false
      is(:absence?, :one, list).should be_false
      is_error :absence? { is!(:absence?, :one, list) }

      Valid.absence?(:false, list).should be_false
      is(:absence?, :false, list).should be_false
      is_error :absence? { is!(:absence?, :false, list) }

      Valid.absence?("present", list).should be_false
      is(:absence?, "present", list).should be_false
      is_error :absence? { is!(:absence?, "present", list) }

      Valid.absence?(:int32_array, list).should be_false
      is(:absence?, :int32_array, list).should be_false
      is_error :absence? { is!(:absence?, :int32_array, list) }
    end
  end

  context "NamedTuple" do
    list = get_named_tuple

    it "should return true if absent" do
      Valid.absence?(:zero, list).should be_true
      is(:absence?, :zero, list).should be_true
      is!(:absence?, :zero, list).should be_true

      Valid.absence?(:nil, list).should be_true
      is(:absence?, :nil, list).should be_true
      is!(:absence?, :nil, list).should be_true

      Valid.absence?(:blank_str, list).should be_true
      is(:absence?, :blank_str, list).should be_true
      is!(:absence?, :blank_str, list).should be_true

      Valid.absence?(:space, list).should be_true
      is(:absence?, :space, list).should be_true
      is!(:absence?, :space, list).should be_true

      Valid.absence?(:empty_array, list).should be_true
      is(:absence?, :empty_array, list).should be_true
      is!(:absence?, :empty_array, list).should be_true

      Valid.absence?("empty_array", list).should be_true
      is(:absence?, "empty_array", list).should be_true
      is!(:absence?, "empty_array", list).should be_true

      Valid.absence?(:absent, list).should be_true
      is(:absence?, :absent, list).should be_true
      is!(:absence?, :absent, list).should be_true

      Valid.absence?("absent", list).should be_true
      is(:absence?, "absent", list).should be_true
      is!(:absence?, "absent", list).should be_true
    end

    it "should return false if not absent" do
      Valid.absence?(:one, list).should be_false
      is(:absence?, :one, list).should be_false
      is_error :absence? { is!(:absence?, :one, list) }

      Valid.absence?(:false, list).should be_false
      is(:absence?, :false, list).should be_false
      is_error :absence? { is!(:absence?, :false, list) }

      Valid.absence?(:present, list).should be_false
      is(:absence?, :present, list).should be_false
      is_error :absence? { is!(:absence?, :present, list) }

      Valid.absence?("present", list).should be_false
      is(:absence?, "present", list).should be_false
      is_error :absence? { is!(:absence?, "present", list) }

      Valid.absence?(:int32_array, list).should be_false
      is(:absence?, :int32_array, list).should be_false
      is_error :absence? { is!(:absence?, :int32_array, list) }
    end
  end
end
