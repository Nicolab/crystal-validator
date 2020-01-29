# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#in?" do
  context "String" do
    it "should return true if in" do
      Valid.in?("cd", "abcdef").should be_true
      is(:in?, "cd", "abcdef").should be_true
      is!(:in?, "cd", "abcdef").should be_true
    end

    it "should return false if not in" do
      Valid.in?("fe", "abcdef").should be_false
      is(:in?, "fe", "abcdef").should be_false
      is_error :in? { is!(:in?, "fe", "abcdef") }
    end
  end

  context "Array" do
    list = get_array

    it "should return true if in" do
      Valid.in?(0, list).should be_true
      is(:in?, 0, list).should be_true
      is!(:in?, 0, list).should be_true

      Valid.in?(1, list).should be_true
      is(:in?, 1, list).should be_true
      is!(:in?, 1, list).should be_true

      Valid.in?(false, list).should be_true
      is(:in?, false, list).should be_true
      is!(:in?, false, list).should be_true

      Valid.in?(nil, list).should be_true
      is(:in?, nil, list).should be_true
      is!(:in?, nil, list).should be_true

      Valid.in?("0", list).should be_true
      is(:in?, "0", list).should be_true
      is!(:in?, "0", list).should be_true

      Valid.in?("", list).should be_true
      is(:in?, "", list).should be_true
      is!(:in?, "", list).should be_true

      Valid.in?(" ", list).should be_true
      is(:in?, " ", list).should be_true
      is!(:in?, " ", list).should be_true

      Valid.in?([42], list).should be_true
      is(:in?, [42], list).should be_true
      is!(:in?, [42], list).should be_true

      Valid.in?("abc", list).should be_true
      is(:in?, "abc", list).should be_true
      is!(:in?, "abc", list).should be_true
    end

    it "should return false if not in" do
      Valid.in?(true, list).should be_false
      is(:in?, true, list).should be_false
      is_error :in? { is!(:in?, true, list) }

      Valid.in?(2, list).should be_false
      is(:in?, 2, list).should be_false
      is_error :in? { is!(:in?, 2, list) }

      Valid.in?(10, list).should be_false
      is(:in?, 10, list).should be_false
      is_error :in? { is!(:in?, 10, list) }

      Valid.in?("10", list).should be_false
      is(:in?, "10", list).should be_false
      is_error :in? { is!(:in?, "10", list) }

      Valid.in?("  ", list).should be_false
      is(:in?, "  ", list).should be_false
      is_error :in? { is!(:in?, "  ", list) }

      Valid.in?([40], list).should be_false
      is(:in?, [40], list).should be_false
      is_error :in? { is!(:in?, [40], list) }

      Valid.in?([1], list).should be_false
      is(:in?, [1], list).should be_false
      is_error :in? { is!(:in?, [1], list) }

      Valid.in?([false], list).should be_false
      is(:in?, [false], list).should be_false
      is_error :in? { is!(:in?, [false], list) }
    end
  end

  context "Tuple" do
    list = get_tuple

    it "should return true if in" do
      Valid.in?(0, list).should be_true
      is(:in?, 0, list).should be_true
      is!(:in?, 0, list).should be_true

      Valid.in?(1, list).should be_true
      is(:in?, 1, list).should be_true
      is!(:in?, 1, list).should be_true

      Valid.in?(false, list).should be_true
      is(:in?, false, list).should be_true
      is!(:in?, false, list).should be_true

      Valid.in?(nil, list).should be_true
      is(:in?, nil, list).should be_true
      is!(:in?, nil, list).should be_true

      Valid.in?("0", list).should be_true
      is(:in?, "0", list).should be_true
      is!(:in?, "0", list).should be_true

      Valid.in?("", list).should be_true
      is(:in?, "", list).should be_true
      is!(:in?, "", list).should be_true

      Valid.in?(" ", list).should be_true
      is(:in?, " ", list).should be_true
      is!(:in?, " ", list).should be_true

      Valid.in?([42], list).should be_true
      is(:in?, [42], list).should be_true
      is!(:in?, [42], list).should be_true

      Valid.in?("abc", list).should be_true
      is(:in?, "abc", list).should be_true
      is!(:in?, "abc", list).should be_true
    end

    it "should return false if not in" do
      Valid.in?(true, list).should be_false
      is(:in?, true, list).should be_false
      is_error :in? { is!(:in?, true, list) }

      Valid.in?(2, list).should be_false
      is(:in?, 2, list).should be_false
      is_error :in? { is!(:in?, 2, list) }

      Valid.in?(10, list).should be_false
      is(:in?, 10, list).should be_false
      is_error :in? { is!(:in?, 10, list) }

      Valid.in?("10", list).should be_false
      is(:in?, "10", list).should be_false
      is_error :in? { is!(:in?, "10", list) }

      Valid.in?("  ", list).should be_false
      is(:in?, "  ", list).should be_false
      is_error :in? { is!(:in?, "  ", list) }

      Valid.in?([40], list).should be_false
      is(:in?, [40], list).should be_false
      is_error :in? { is!(:in?, [40], list) }

      Valid.in?([1], list).should be_false
      is(:in?, [1], list).should be_false
      is_error :in? { is!(:in?, [1], list) }

      Valid.in?([false], list).should be_false
      is(:in?, [false], list).should be_false
      is_error :in? { is!(:in?, [false], list) }
    end
  end

  context "Range" do
    it "should return true if in" do
      Valid.in?(10, 0..10).should be_true
      is(:in?, 10, 0..10).should be_true
      is!(:in?, 10, 0..10)
    end

    it "should return false if not in" do
      Valid.in?(10, 0...10).should be_false
      is(:in?, 10, 0...10).should be_false
      is_error :in? { is!(:in?, 10, 0...10) }
    end
  end

  context "NamedTuple" do
    list = get_named_tuple

    it "should return true if in" do
      Valid.in?(:zero, list).should be_true
      is(:in?, :zero, list).should be_true
      is!(:in?, :zero, list).should be_true

      Valid.in?(:one, list).should be_true
      is(:in?, :one, list).should be_true
      is!(:in?, :one, list).should be_true

      Valid.in?("one", list).should be_true
      is(:in?, "one", list).should be_true
      is!(:in?, "one", list).should be_true

      Valid.in?(:false, list).should be_true
      is(:in?, :false, list).should be_true
      is!(:in?, :false, list).should be_true

      Valid.in?(:nil, list).should be_true
      is(:in?, :nil, list).should be_true
      is!(:in?, :nil, list).should be_true

      Valid.in?("nil", list).should be_true
      is(:in?, "nil", list).should be_true
      is!(:in?, "nil", list).should be_true
    end

    it "should return false if not in" do
      Valid.in?(:true, list).should be_false
      is(:in?, :true, list).should be_false
      is_error :in? { is!(:in?, :true, list) }

      Valid.in?(:onee, list).should be_false
      is(:in?, :onee, list).should be_false
      is_error :in? { is!(:in?, :onee, list) }

      Valid.in?("onee", list).should be_false
      is(:in?, "onee", list).should be_false
      is_error :in? { is!(:in?, "onee", list) }
    end
  end

  context "Hash" do
    list = get_hash

    it "should return true if in" do
      Valid.in?(:zero, list).should be_true
      is(:in?, :zero, list).should be_true
      is!(:in?, :zero, list).should be_true

      Valid.in?(:one, list).should be_true
      is(:in?, :one, list).should be_true
      is!(:in?, :one, list).should be_true

      Valid.in?(:false, list).should be_true
      is(:in?, :false, list).should be_true
      is!(:in?, :false, list).should be_true

      Valid.in?(:nil, list).should be_true
      is(:in?, :nil, list).should be_true
      is!(:in?, :nil, list).should be_true

      Valid.in?("nil", list).should be_true
      is(:in?, "nil", list).should be_true
      is!(:in?, "nil", list).should be_true
    end

    it "should return false if not in" do
      Valid.in?(:true, list).should be_false
      is(:in?, :true, list).should be_false
      is_error :in? { is!(:in?, :true, list) }

      Valid.in?("one", list).should be_false
      is(:in?, "one", list).should be_false
      is_error :in? { is!(:in?, "one", list) }

      Valid.in?(:onee, list).should be_false
      is(:in?, :onee, list).should be_false
      is_error :in? { is!(:in?, :onee, list) }

      Valid.in?("onee", list).should be_false
      is(:in?, "onee", list).should be_false
      is_error :in? { is!(:in?, "onee", list) }
    end
  end
end

describe "Valid#not_in?" do
  context "String" do
    it "should return true if not in" do
      Valid.not_in?("fe", "abcdef").should be_true
      is(:not_in?, "fe", "abcdef").should be_true
      is!(:not_in?, "fe", "abcdef").should be_true
    end

    it "should return false if in" do
      Valid.not_in?("cd", "abcdef").should be_false
      is(:not_in?, "cd", "abcdef").should be_false
      is_error :not_in? { is!(:not_in?, "cd", "abcdef") }
    end
  end

  context "Array" do
    list = get_array

    it "should return true if not in" do
      Valid.not_in?(true, list).should be_true
      is(:not_in?, true, list).should be_true
      is!(:not_in?, true, list).should be_true

      Valid.not_in?(2, list).should be_true
      is(:not_in?, 2, list).should be_true
      is!(:not_in?, 2, list).should be_true

      Valid.not_in?(10, list).should be_true
      is(:not_in?, 10, list).should be_true
      is!(:not_in?, 10, list).should be_true

      Valid.not_in?("10", list).should be_true
      is(:not_in?, "10", list).should be_true
      is!(:not_in?, "10", list).should be_true

      Valid.not_in?("  ", list).should be_true
      is(:not_in?, "  ", list).should be_true
      is!(:not_in?, "  ", list).should be_true

      Valid.not_in?([40], list).should be_true
      is(:not_in?, [40], list).should be_true
      is!(:not_in?, [40], list).should be_true

      Valid.not_in?([1], list).should be_true
      is(:not_in?, [1], list).should be_true
      is!(:not_in?, [1], list).should be_true

      Valid.not_in?([false], list).should be_true
      is(:not_in?, [false], list).should be_true
      is!(:not_in?, [false], list).should be_true
    end

    it "should return false if in" do
      Valid.not_in?(0, list).should be_false
      is(:not_in?, 0, list).should be_false
      is_error :not_in? { is!(:not_in?, 0, list) }

      Valid.not_in?(1, list).should be_false
      is(:not_in?, 1, list).should be_false
      is_error :not_in? { is!(:not_in?, 1, list) }

      Valid.not_in?(false, list).should be_false
      is(:not_in?, false, list).should be_false
      is_error :not_in? { is!(:not_in?, false, list) }

      Valid.not_in?(nil, list).should be_false
      is(:not_in?, nil, list).should be_false
      is_error :not_in? { is!(:not_in?, nil, list) }

      Valid.not_in?("0", list).should be_false
      is(:not_in?, "0", list).should be_false
      is_error :not_in? { is!(:not_in?, "0", list) }

      Valid.not_in?("", list).should be_false
      is(:not_in?, "", list).should be_false
      is_error :not_in? { is!(:not_in?, "", list) }

      Valid.not_in?(" ", list).should be_false
      is(:not_in?, " ", list).should be_false
      is_error :not_in? { is!(:not_in?, " ", list) }

      Valid.not_in?([42], list).should be_false
      is(:not_in?, [42], list).should be_false
      is_error :not_in? { is!(:not_in?, [42], list) }

      Valid.not_in?("abc", list).should be_false
      is(:not_in?, "abc", list).should be_false
      is_error :not_in? { is!(:not_in?, "abc", list) }
    end
  end

  context "Tuple" do
    list = get_tuple

    it "should return true if not in" do
      Valid.not_in?(true, list).should be_true
      is(:not_in?, true, list).should be_true
      is!(:not_in?, true, list).should be_true

      Valid.not_in?(2, list).should be_true
      is(:not_in?, 2, list).should be_true
      is!(:not_in?, 2, list).should be_true

      Valid.not_in?(10, list).should be_true
      is(:not_in?, 10, list).should be_true
      is!(:not_in?, 10, list).should be_true

      Valid.not_in?("10", list).should be_true
      is(:not_in?, "10", list).should be_true
      is!(:not_in?, "10", list).should be_true

      Valid.not_in?("  ", list).should be_true
      is(:not_in?, "  ", list).should be_true
      is!(:not_in?, "  ", list).should be_true

      Valid.not_in?([40], list).should be_true
      is(:not_in?, [40], list).should be_true
      is!(:not_in?, [40], list).should be_true

      Valid.not_in?([1], list).should be_true
      is(:not_in?, [1], list).should be_true
      is!(:not_in?, [1], list).should be_true

      Valid.not_in?([false], list).should be_true
      is(:not_in?, [false], list).should be_true
      is!(:not_in?, [false], list).should be_true
    end

    it "should return false if in" do
      Valid.not_in?(0, list).should be_false
      is(:not_in?, 0, list).should be_false
      is_error :not_in? { is!(:not_in?, 0, list) }

      Valid.not_in?(1, list).should be_false
      is(:not_in?, 1, list).should be_false
      is_error :not_in? { is!(:not_in?, 1, list) }

      Valid.not_in?(false, list).should be_false
      is(:not_in?, false, list).should be_false
      is_error :not_in? { is!(:not_in?, false, list) }

      Valid.not_in?(nil, list).should be_false
      is(:not_in?, nil, list).should be_false
      is_error :not_in? { is!(:not_in?, nil, list) }

      Valid.not_in?("0", list).should be_false
      is(:not_in?, "0", list).should be_false
      is_error :not_in? { is!(:not_in?, "0", list) }

      Valid.not_in?("", list).should be_false
      is(:not_in?, "", list).should be_false
      is_error :not_in? { is!(:not_in?, "", list) }

      Valid.not_in?(" ", list).should be_false
      is(:not_in?, " ", list).should be_false
      is_error :not_in? { is!(:not_in?, " ", list) }

      Valid.not_in?([42], list).should be_false
      is(:not_in?, [42], list).should be_false
      is_error :not_in? { is!(:not_in?, [42], list) }

      Valid.not_in?("abc", list).should be_false
      is(:not_in?, "abc", list).should be_false
      is_error :not_in? { is!(:not_in?, "abc", list) }
    end
  end

  context "Range" do
    it "should return true if not in" do
      Valid.not_in?(10, 0...10).should be_true
      is(:not_in?, 10, 0...10).should be_true
      is!(:not_in?, 10, 0...10).should be_true
    end

    it "should return false if in" do
      Valid.not_in?(10, 0..10).should be_false
      is(:not_in?, 10, 0..10).should be_false
      is_error :not_in? { is!(:not_in?, 10, 0..10) }
    end
  end

  context "NamedTuple" do
    list = get_named_tuple

    it "should return true if not in" do
      Valid.not_in?(:true, list).should be_true
      is(:not_in?, :true, list).should be_true
      is!(:not_in?, :true, list).should be_true

      Valid.not_in?(:onee, list).should be_true
      is(:not_in?, :onee, list).should be_true
      is!(:not_in?, :onee, list).should be_true

      Valid.not_in?("onee", list).should be_true
      is(:not_in?, "onee", list).should be_true
      is!(:not_in?, "onee", list).should be_true
    end

    it "should return false if in" do
      Valid.not_in?(:zero, list).should be_false
      is(:not_in?, :zero, list).should be_false
      is_error :not_in? { is!(:not_in?, :zero, list) }

      Valid.not_in?(:one, list).should be_false
      is(:not_in?, :one, list).should be_false
      is_error :not_in? { is!(:not_in?, :one, list) }

      Valid.not_in?("one", list).should be_false
      is(:not_in?, "one", list).should be_false
      is_error :not_in? { is!(:not_in?, "one", list) }

      Valid.not_in?(:false, list).should be_false
      is(:not_in?, :false, list).should be_false
      is_error :not_in? { is!(:not_in?, :false, list) }

      Valid.not_in?(:nil, list).should be_false
      is(:not_in?, :nil, list).should be_false
      is_error :not_in? { is!(:not_in?, :nil, list) }

      Valid.not_in?("nil", list).should be_false
      is(:not_in?, "nil", list).should be_false
      is_error :not_in? { is!(:not_in?, "nil", list) }
    end
  end

  context "Hash" do
    list = get_hash

    it "should return true if not in" do
      Valid.not_in?(:true, list).should be_true
      is(:not_in?, :true, list).should be_true
      is!(:not_in?, :true, list).should be_true

      Valid.not_in?("one", list).should be_true
      is(:not_in?, "one", list).should be_true
      is!(:not_in?, "one", list).should be_true

      Valid.not_in?(:onee, list).should be_true
      is(:not_in?, :onee, list).should be_true
      is!(:not_in?, :onee, list).should be_true

      Valid.not_in?("onee", list).should be_true
      is(:not_in?, "onee", list).should be_true
      is!(:not_in?, "onee", list).should be_true
    end

    it "should return false if in" do
      Valid.not_in?(:zero, list).should be_false
      is(:not_in?, :zero, list).should be_false
      is_error :not_in? { is!(:not_in?, :zero, list) }

      Valid.not_in?(:one, list).should be_false
      is(:not_in?, :one, list).should be_false
      is_error :not_in? { is!(:not_in?, :one, list) }

      Valid.not_in?(:false, list).should be_false
      is(:not_in?, :false, list).should be_false
      is_error :not_in? { is!(:not_in?, :false, list) }

      Valid.not_in?(:nil, list).should be_false
      is(:not_in?, :nil, list).should be_false
      is_error :not_in? { is!(:not_in?, :nil, list) }

      Valid.not_in?("nil", list).should be_false
      is(:not_in?, "nil", list).should be_false
      is_error :not_in? { is!(:not_in?, "nil", list) }
    end
  end
end
