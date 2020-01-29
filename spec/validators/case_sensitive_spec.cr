# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#lower?" do
  it "should return true if lower" do
    Valid.lower?("a").should be_true
    is(:lower?, "a").should be_true
    is!(:lower?, "a")

    Valid.lower?("a b").should be_true
    is(:lower?, "a b").should be_true
    is!(:lower?, "a b")

    Valid.lower?("abc").should be_true
    is(:lower?, "abc").should be_true
    is!(:lower?, "abc")

    Valid.lower?("a!").should be_true
    is(:lower?, "a!").should be_true
    is!(:lower?, "a!+-_'\"'~&")

    Valid.lower?("0").should be_true
    is(:lower?, "0").should be_true
    is!(:lower?, "0")
  end

  it "should return false if not lower" do
    Valid.lower?("").should be_false
    is(:lower?, "").should be_false
    is_error :lower? { is!(:lower?, "") }

    Valid.lower?(" ").should be_false
    is(:lower?, " ").should be_false
    is_error :lower? { is!(:lower?, " ") }

    Valid.lower?("A").should be_false
    is(:lower?, "A").should be_false
    is_error :lower? { is!(:lower?, "A") }

    Valid.lower?("A B").should be_false
    is(:lower?, "A B").should be_false
    is_error :lower? { is!(:lower?, "A B") }

    Valid.lower?("ABC").should be_false
    is(:lower?, "ABC").should be_false
    is_error :lower? { is!(:lower?, "ABC") }

    Valid.lower?("A!").should be_false
    is(:lower?, "A!").should be_false
    is_error :lower? { is!(:lower?, "A!+-_'\"'~&") }
  end
end

describe "Valid#upper?" do
  it "should return true if upper" do
    Valid.upper?("A").should be_true
    is(:upper?, "A").should be_true
    is!(:upper?, "A")

    Valid.upper?("A B").should be_true
    is(:upper?, "A B").should be_true
    is!(:upper?, "A B")

    Valid.upper?("ABC").should be_true
    is(:upper?, "ABC").should be_true
    is!(:upper?, "ABC")

    Valid.upper?("A!").should be_true
    is(:upper?, "A!").should be_true
    is!(:upper?, "A!+-_'\"'~&")

    Valid.upper?("0").should be_true
    is(:upper?, "0").should be_true
    is!(:upper?, "0")
  end

  it "should return false if not upper" do
    Valid.upper?("").should be_false
    is(:upper?, "").should be_false
    is_error :upper? { is!(:upper?, "") }

    Valid.upper?(" ").should be_false
    is(:upper?, " ").should be_false
    is_error :upper? { is!(:upper?, " ") }

    Valid.upper?("a").should be_false
    is(:upper?, "a").should be_false
    is_error :upper? { is!(:upper?, "a") }

    Valid.upper?("a b").should be_false
    is(:upper?, "a b").should be_false
    is_error :upper? { is!(:upper?, "a b") }

    Valid.upper?("abc").should be_false
    is(:upper?, "abc").should be_false
    is_error :upper? { is!(:upper?, "abc") }

    Valid.upper?("a!").should be_false
    is(:upper?, "a!").should be_false
    is_error :upper? { is!(:upper?, "a!+-_'\"'~&") }
  end
end
