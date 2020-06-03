# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "spec"

require "../src/validator"
require "../src/is"
require "../src/check"

require "./checkable_helper"

# Get a Hash
def get_hash : Hash
  {
    :zero        => 0,
    :one         => 1,
    :false       => false,
    :nil         => nil,
    :blank_str   => "",
    :space       => " ",
    :empty_array => [] of Bool,
    :int32_array => [42],
    "present"    => "abc",
    "nil"        => nil,
  }
end

# Get a NamedTuple
def get_named_tuple : NamedTuple
  {
    zero:        0,
    one:         1,
    false:       false,
    nil:         nil,
    blank_str:   "",
    space:       " ",
    empty_array: [] of Bool,
    int32_array: [42],
    present:     "abc",
  }
end

# Get an Tuple
def get_tuple : Tuple
  {
    0,
    1,
    false,
    nil,
    "0",
    "",
    " ",
    [] of Bool,
    [42],
    "abc",
  }
end

# Get an Array
def get_array : Array
  get_tuple.to_a
end

# Expect raises a `Validator::Error` for `is!`.
def is_error(validator : String | Symbol, &block)
  expect_raises(Valid::Error, /^Is not "#{validator}\?":\n\s*(.+)}$/) do
    yield
  end
end

describe "spec_helper" do
  it "is_error" do
    raised = false

    begin
      is_error :eq? { is!(:eq?, true, true) }
    rescue exception
      raised = true
    end

    raised.should be_true
  end
end
