# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#starts?" do
  context "String" do
    it "should return true if starts with the value" do
      Valid.starts?("abcdef", "a").should be_true
      is(:starts?, "abcdef", "a").should be_true
      is!(:starts?, "abcdef", "a").should be_true

      Valid.starts?("abcdef", "abc").should be_true
      is(:starts?, "abcdef", "abc").should be_true
      is!(:starts?, "abcdef", "abc").should be_true
    end

    it "should return false if not starts with the value" do
      Valid.starts?("abcdef", "f").should be_false
      is(:starts?, "abcdef", "f").should be_false
      is_error :starts? { is!(:starts?, "abcdef", "f") }

      Valid.starts?("abcdef", "xyz").should be_false
      is(:starts?, "abcdef", "xyz").should be_false
      is_error :starts? { is!(:starts?, "abcdef", "xyz") }
    end
  end

  context "Char" do
    it "should return true if starts with the value" do
      Valid.starts?("abcdef", 'a').should be_true
      is(:starts?, "abcdef", 'a').should be_true
      is!(:starts?, "abcdef", 'a').should be_true
    end

    it "should return false if not starts with the value" do
      Valid.starts?("abcdef", 'f').should be_false
      is(:starts?, "abcdef", 'f').should be_false
      is_error :starts? { is!(:starts?, "abcdef", 'f') }
    end
  end

  context "Regex" do
    it "should return true if starts with the value" do
      Valid.starts?("abcdef", /^a/).should be_true
      is(:starts?, "abcdef", /^a/).should be_true
      is!(:starts?, "abcdef", /^a/).should be_true

      Valid.starts?("abcdef", /abc/).should be_true
      is(:starts?, "abcdef", /abc/).should be_true
      is!(:starts?, "abcdef", /abc/).should be_true

      Valid.starts?("bcdef", /a|b/).should be_true
      is(:starts?, "bcdef", /a|b/).should be_true
      is!(:starts?, "bcdef", /a|b/).should be_true
    end

    it "should return false if not starts with the value" do
      Valid.starts?("abcdef", /f/).should be_false
      is(:starts?, "abcdef", /f/).should be_false
      is_error :starts? { is!(:starts?, "abcdef", /f/) }

      Valid.starts?("abcdef", /f$/).should be_false
      is(:starts?, "abcdef", /f$/).should be_false
      is_error :starts? { is!(:starts?, "abcdef", /f$/) }

      Valid.starts?("abcdef", /xyz/).should be_false
      is(:starts?, "abcdef", /xyz/).should be_false
      is_error :starts? { is!(:starts?, "abcdef", /xyz/) }
    end
  end
end

describe "Valid#ends?" do
  context "String" do
    it "should return true if ends with the value" do
      Valid.ends?("abcdef", "f").should be_true
      is(:ends?, "abcdef", "f").should be_true
      is!(:ends?, "abcdef", "f").should be_true

      Valid.ends?("abcdef", "def").should be_true
      is(:ends?, "abcdef", "def").should be_true
      is!(:ends?, "abcdef", "def").should be_true
    end

    it "should return false if not ends with the value" do
      Valid.ends?("abcdef", "a").should be_false
      is(:ends?, "abcdef", "a").should be_false
      is_error :ends? { is!(:ends?, "abcdef", "a") }

      Valid.ends?("abcdef", "xyz").should be_false
      is(:ends?, "abcdef", "xyz").should be_false
      is_error :ends? { is!(:ends?, "abcdef", "xyz") }
    end
  end

  context "Char" do
    it "should return true if ends with the value" do
      Valid.ends?("abcdef", 'f').should be_true
      is(:ends?, "abcdef", 'f').should be_true
      is!(:ends?, "abcdef", 'f').should be_true
    end

    it "should return false if not ends with the value" do
      Valid.ends?("abcdef", 'a').should be_false
      is(:ends?, "abcdef", 'a').should be_false
      is_error :ends? { is!(:ends?, "abcdef", 'a') }
    end
  end

  context "Regex" do
    it "should return true if ends with the value" do
      Valid.ends?("abcdef", /f$/).should be_true
      is(:ends?, "abcdef", /f$/).should be_true
      is!(:ends?, "abcdef", /f$/).should be_true

      Valid.ends?("abcdef", /def/).should be_true
      is(:ends?, "abcdef", /def/).should be_true
      is!(:ends?, "abcdef", /def/).should be_true

      Valid.ends?("abcde", /f|e/).should be_true
      is(:ends?, "abcde", /f|e/).should be_true
      is!(:ends?, "abcde", /f|e/).should be_true
    end

    it "should return false if not ends with the value" do
      Valid.ends?("abcdef", /a/).should be_false
      is(:ends?, "abcdef", /a/).should be_false
      is_error :ends? { is!(:ends?, "abcdef", /a/) }

      Valid.ends?("abcdef", /^a/).should be_false
      is(:ends?, "abcdef", /^a/).should be_false
      is_error :ends? { is!(:ends?, "abcdef", /^a/) }

      Valid.ends?("abcdef", /xyz/).should be_false
      is(:ends?, "abcdef", /xyz/).should be_false
      is_error :ends? { is!(:ends?, "abcdef", /xyz/) }
    end
  end
end
