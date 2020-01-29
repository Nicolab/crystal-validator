# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#empty?" do
  list = get_hash

  it "should return true if empty" do
    Valid.empty?(list[:zero]?).should be_true
    is(:empty?, list[:zero]?).should be_true
    is!(:empty?, list[:zero]?).should be_true

    Valid.empty?(list[:nil]?).should be_true
    is(:empty?, list[:nil]?).should be_true
    is!(:empty?, list[:nil]?).should be_true

    Valid.empty?(list["nil"]?).should be_true
    is(:empty?, list["nil"]?).should be_true
    is!(:empty?, list["nil"]?).should be_true

    Valid.empty?(list[:blank_str]?).should be_true
    is(:empty?, list[:blank_str]?).should be_true
    is!(:empty?, list[:blank_str]?).should be_true

    Valid.empty?(list[:space]?).should be_true
    is(:empty?, list[:space]?).should be_true
    is!(:empty?, list[:space]?).should be_true

    Valid.empty?(list[:empty_array]?).should be_true
    is(:empty?, list[:empty_array]?).should be_true
    is!(:empty?, list[:empty_array]?).should be_true

    Valid.empty?(list["absent"]?).should be_true
    is(:empty?, list["absent"]?).should be_true
    is!(:empty?, list["absent"]?).should be_true
  end

  it "should return false if not empty" do
    Valid.empty?(list[:one]?).should be_false
    is(:empty?, list[:one]?).should be_false
    is_error :empty? { is!(:empty?, list[:one]?) }

    Valid.empty?(list[:false]?).should be_false
    is(:empty?, list[:false]?).should be_false
    is_error :empty? { is!(:empty?, list[:false]?) }

    Valid.empty?(list["present"]?).should be_false
    is(:empty?, list["present"]?).should be_false
    is_error :empty? { is!(:empty?, list["present"]?) }
  end
end

describe "Valid#not_empty?" do
  list = get_hash

  it "should return true if not empty" do
    Valid.not_empty?(list[:one]?).should be_true
    is(:not_empty?, list[:one]?).should be_true
    is!(:not_empty?, list[:one]?).should be_true

    Valid.not_empty?(list[:false]?).should be_true
    is(:not_empty?, list[:false]?).should be_true
    is!(:not_empty?, list[:false]?).should be_true

    Valid.not_empty?(list["present"]?).should be_true
    is(:not_empty?, list["present"]?).should be_true
    is!(:not_empty?, list["present"]?).should be_true
  end

  it "should return false if empty" do
    Valid.not_empty?(list[:zero]?).should be_false
    is(:not_empty?, list[:zero]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list[:zero]?) }

    Valid.not_empty?(list[:nil]?).should be_false
    is(:not_empty?, list[:nil]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list[:nil]?) }

    Valid.not_empty?(list["nil"]?).should be_false
    is(:not_empty?, list["nil"]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list["nil"]?) }

    Valid.not_empty?(list[:blank_str]?).should be_false
    is(:not_empty?, list[:blank_str]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list[:blank_str]?) }

    Valid.not_empty?(list[:space]?).should be_false
    is(:not_empty?, list[:space]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list[:space]?) }

    Valid.not_empty?(list[:empty_array]?).should be_false
    is(:not_empty?, list[:empty_array]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list[:empty_array]?) }

    Valid.not_empty?(list["absent"]?).should be_false
    is(:not_empty?, list["absent"]?).should be_false
    is_error :not_empty? { is!(:not_empty?, list["absent"]?) }
  end
end
