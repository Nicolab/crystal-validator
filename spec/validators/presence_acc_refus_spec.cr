# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#accepted?" do
  it "should return true if accepted" do
    Valid.accepted?("yes").should be_true
    is(:accepted?, "yes").should be_true
    is!(:accepted?, "yes").should be_true

    Valid.accepted?(:yes).should be_true
    is(:accepted?, :yes).should be_true
    is!(:accepted?, :yes).should be_true

    Valid.accepted?("y").should be_true
    is(:accepted?, "y").should be_true
    is!(:accepted?, "y").should be_true

    Valid.accepted?(:y).should be_true
    is(:accepted?, :y).should be_true
    is!(:accepted?, :y).should be_true

    Valid.accepted?("on").should be_true
    is(:accepted?, "on").should be_true
    is!(:accepted?, "on").should be_true

    Valid.accepted?(:on).should be_true
    is(:accepted?, :on).should be_true
    is!(:accepted?, :on).should be_true

    Valid.accepted?("o").should be_true
    is(:accepted?, "o").should be_true
    is!(:accepted?, "o").should be_true

    Valid.accepted?(:o).should be_true
    is(:accepted?, :o).should be_true
    is!(:accepted?, :o).should be_true

    Valid.accepted?("ok").should be_true
    is(:accepted?, "ok").should be_true
    is!(:accepted?, "ok").should be_true

    Valid.accepted?(:ok).should be_true
    is(:accepted?, :ok).should be_true
    is!(:accepted?, :ok).should be_true

    Valid.accepted?("1").should be_true
    is(:accepted?, "1").should be_true
    is!(:accepted?, "1").should be_true

    Valid.accepted?(1).should be_true
    is(:accepted?, 1).should be_true
    is!(:accepted?, 1).should be_true

    Valid.accepted?("true").should be_true
    is(:accepted?, "true").should be_true
    is!(:accepted?, "true").should be_true

    Valid.accepted?(:true).should be_true
    is(:accepted?, :true).should be_true
    is!(:accepted?, :true).should be_true

    Valid.accepted?(true).should be_true
    is(:accepted?, true).should be_true
    is!(:accepted?, true).should be_true
  end

  it "should return false if not accepted" do
    Valid.accepted?("").should be_false
    is(:accepted?, "").should be_false
    is_error :accepted? { is!(:accepted?, "") }

    Valid.accepted?("no").should be_false
    is(:accepted?, "no").should be_false
    is_error :accepted? { is!(:accepted?, "no") }

    Valid.accepted?(:no).should be_false
    is(:accepted?, :no).should be_false
    is_error :accepted? { is!(:accepted?, :no) }

    Valid.accepted?("n").should be_false
    is(:accepted?, "n").should be_false
    is_error :accepted? { is!(:accepted?, "n") }

    Valid.accepted?(:n).should be_false
    is(:accepted?, :n).should be_false
    is_error :accepted? { is!(:accepted?, :n) }

    Valid.accepted?("off").should be_false
    is(:accepted?, "off").should be_false
    is_error :accepted? { is!(:accepted?, "off") }

    Valid.accepted?(:off).should be_false
    is(:accepted?, :off).should be_false
    is_error :accepted? { is!(:accepted?, :off) }

    Valid.accepted?("0").should be_false
    is(:accepted?, "0").should be_false
    is_error :accepted? { is!(:accepted?, "0") }

    Valid.accepted?(0).should be_false
    is(:accepted?, 0).should be_false
    is_error :accepted? { is!(:accepted?, 0) }

    Valid.accepted?("false").should be_false
    is(:accepted?, "false").should be_false
    is_error :accepted? { is!(:accepted?, "false") }

    Valid.accepted?(:false).should be_false
    is(:accepted?, :false).should be_false
    is_error :accepted? { is!(:accepted?, :false) }

    Valid.accepted?(false).should be_false
    is(:accepted?, false).should be_false
    is_error :accepted? { is!(:accepted?, false) }
  end
end

# ["no", "n", "off", "0", "false"]
describe "Valid#refused?" do
  it "should return true if refused" do
    Valid.refused?("no").should be_true
    is(:refused?, "no").should be_true
    is!(:refused?, "no").should be_true

    Valid.refused?(:no).should be_true
    is(:refused?, :no).should be_true
    is!(:refused?, :no).should be_true

    Valid.refused?("n").should be_true
    is(:refused?, "n").should be_true
    is!(:refused?, "n").should be_true

    Valid.refused?(:n).should be_true
    is(:refused?, :n).should be_true
    is!(:refused?, :n).should be_true

    Valid.refused?("off").should be_true
    is(:refused?, "off").should be_true
    is!(:refused?, "off").should be_true

    Valid.refused?(:off).should be_true
    is(:refused?, :off).should be_true
    is!(:refused?, :off).should be_true

    Valid.refused?("0").should be_true
    is(:refused?, "0").should be_true
    is!(:refused?, "0").should be_true

    Valid.refused?(0).should be_true
    is(:refused?, 0).should be_true
    is!(:refused?, 0).should be_true

    Valid.refused?("false").should be_true
    is(:refused?, "false").should be_true
    is!(:refused?, "false").should be_true

    Valid.refused?(:false).should be_true
    is(:refused?, :false).should be_true
    is!(:refused?, :false).should be_true

    Valid.refused?(false).should be_true
    is(:refused?, false).should be_true
    is!(:refused?, false).should be_true
  end

  it "should return false if not refused" do
    Valid.refused?("").should be_false
    is(:refused?, "").should be_false
    is_error :refused? { is!(:refused?, "") }

    Valid.refused?("yes").should be_false
    is(:refused?, "yes").should be_false
    is_error :refused? { is!(:refused?, "yes") }

    Valid.refused?(:yes).should be_false
    is(:refused?, :yes).should be_false
    is_error :refused? { is!(:refused?, :yes) }

    Valid.refused?("y").should be_false
    is(:refused?, "y").should be_false
    is_error :refused? { is!(:refused?, "y") }

    Valid.refused?(:y).should be_false
    is(:refused?, :y).should be_false
    is_error :refused? { is!(:refused?, :y) }

    Valid.refused?("on").should be_false
    is(:refused?, "on").should be_false
    is_error :refused? { is!(:refused?, "on") }

    Valid.refused?(:on).should be_false
    is(:refused?, :on).should be_false
    is_error :refused? { is!(:refused?, :on) }

    Valid.refused?("o").should be_false
    is(:refused?, "o").should be_false
    is_error :refused? { is!(:refused?, "o") }

    Valid.refused?(:o).should be_false
    is(:refused?, :o).should be_false
    is_error :refused? { is!(:refused?, :o) }

    Valid.refused?("ok").should be_false
    is(:refused?, "ok").should be_false
    is_error :refused? { is!(:refused?, "ok") }

    Valid.refused?(:ok).should be_false
    is(:refused?, :ok).should be_false
    is_error :refused? { is!(:refused?, :ok) }

    Valid.refused?("1").should be_false
    is(:refused?, "1").should be_false
    is_error :refused? { is!(:refused?, "1") }

    Valid.refused?(1).should be_false
    is(:refused?, 1).should be_false
    is_error :refused? { is!(:refused?, 1) }

    Valid.refused?("true").should be_false
    is(:refused?, "true").should be_false
    is_error :refused? { is!(:refused?, "true") }

    Valid.refused?(:true).should be_false
    is(:refused?, :true).should be_false
    is_error :refused? { is!(:refused?, :true) }

    Valid.refused?(true).should be_false
    is(:refused?, true).should be_false
    is_error :refused? { is!(:refused?, true) }
  end
end
