# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#number?" do
  it "should return true if number" do
    Valid.number?("0").should be_true
    is(:number?, "0").should be_true
    is!(:number?, "0").should be_true

    Valid.number?("1").should be_true
    is(:number?, "1").should be_true
    is!(:number?, "1").should be_true

    Valid.number?("01").should be_true
    is(:number?, "01").should be_true
    is!(:number?, "01").should be_true

    Valid.number?("01.01").should be_true
    is(:number?, "01.01").should be_true
    is!(:number?, "01.01").should be_true

    Valid.number?("1.25584568").should be_true
    is(:number?, "1.25584568").should be_true
    is!(:number?, "1.25584568").should be_true

    Valid.number?("11111111111111111111111111111111.\
      22222222222222222222222").should be_true
    is(:number?, "11111111111111111111111111111111.\
      22222222222222222222222").should be_true
    is!(:number?, "11111111111111111111111111111111.\
      22222222222222222222222").should be_true
  end

  it "should return false if not number" do
    Valid.number?("").should be_false
    is(:number?, "").should be_false
    is_error :number? { is!(:number?, "") }

    Valid.number?(" ").should be_false
    is(:number?, " ").should be_false
    is_error :number? { is!(:number?, " ") }

    Valid.number?("1o").should be_false
    is(:number?, "1o").should be_false
    is_error :number? { is!(:number?, "1o") }

    Valid.number?("1.0.0").should be_false
    is(:number?, "1.0.0").should be_false
    is_error :number? { is!(:number?, "1.0.0") }

    Valid.number?("x").should be_false
    is(:number?, "x").should be_false
    is_error :number? { is!(:number?, "x") }

    Valid.number?("--1").should be_false
    is(:number?, "--1").should be_false
    is_error :number? { is!(:number?, "--1") }

    Valid.number?("++1").should be_false
    is(:number?, "++1").should be_false
    is_error :number? { is!(:number?, "++1") }
  end
end
