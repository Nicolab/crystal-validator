# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#eq?" do
  it "should return true if equality" do
    Valid.eq?(true, true).should be_true
    is(:eq?, true, true).should be_true
    is!(:eq?, true, true).should be_true

    Valid.eq?(1, 1).should be_true
    is(:eq?, 1, 1).should be_true
    is!(:eq?, 1, 1).should be_true

    Valid.eq?("ok", "ok").should be_true
    is(:eq?, "ok", "ok").should be_true
    is!(:eq?, "ok", "ok").should be_true

    Valid.eq?("", "").should be_true
    is(:eq?, "", "").should be_true
    is!(:eq?, "", "").should be_true

    Valid.eq?(:ok, :ok).should be_true
    is(:eq?, :ok, :ok).should be_true
    is!(:eq?, :ok, :ok).should be_true
  end

  it "should return false if inequality" do
    Valid.eq?(true, false).should be_false
    is(:eq?, true, false).should be_false
    is_error :eq? { is!(:eq?, true, false) }

    Valid.eq?(1, 2).should be_false
    is(:eq?, 1, 2).should be_false
    is_error :eq? { is!(:eq?, 1, 2) }

    Valid.eq?("ok", "ko").should be_false
    is(:eq?, "ok", "ko").should be_false
    is_error :eq? { is!(:eq?, "ok", "ko") }

    Valid.eq?(:ok, :ko).should be_false
    is(:eq?, :ok, :ko).should be_false
    is_error :eq? { is!(:eq?, :ok, :ko) }
  end
end

describe "Valid#gt?" do
  it "should return true if greater than" do
    Valid.gt?(2, 1).should be_true
    is(:gt?, 2, 1).should be_true
    is!(:gt?, 2, 1).should be_true

    Valid.gt?("2", "1").should be_true
    is(:gt?, "2", "1").should be_true
    is!(:gt?, "2", "1").should be_true

    Valid.gt?("b", "a").should be_true
    is(:gt?, "b", "a").should be_true
    is!(:gt?, "b", "a").should be_true

    Valid.gt?("bb", "abb").should be_true
    is(:gt?, "bb", "abb").should be_true
    is!(:gt?, "bb", "abb").should be_true

    Valid.gt?(:b, :a).should be_true
    is(:gt?, :b, :a).should be_true
    is!(:gt?, :b, :a).should be_true

    Valid.gt?(:b, :ab).should be_true
    is(:gt?, :b, :ab).should be_true
    is!(:gt?, :b, :ab).should be_true
  end

  it "should return false if not greater than" do
    Valid.gt?(1, 2).should be_false
    is(:gt?, 1, 2).should be_false
    is_error :gt? { is!(:gt?, 1, 2) }

    Valid.gt?("1", "2").should be_false
    is(:gt?, "1", "2").should be_false
    is_error :gt? { is!(:gt?, "1", "2") }

    Valid.gt?("", "").should be_false
    is(:gt?, "", "").should be_false
    is_error :gt? { is!(:gt?, "", "") }

    Valid.gt?("a", "b").should be_false
    is(:gt?, "a", "b").should be_false
    is_error :gt? { is!(:gt?, "a", "b") }

    Valid.gt?("abb", "bb").should be_false
    is(:gt?, "abb", "bb").should be_false
    is_error :gt? { is!(:gt?, "abb", "bb") }

    Valid.gt?(:a, :b).should be_false
    is(:gt?, :a, :b).should be_false
    is_error :gt? { is!(:gt?, :a, :b) }

    Valid.gt?(:ab, :b).should be_false
    is(:gt?, :ab, :b).should be_false
    is_error :gt? { is!(:gt?, :ab, :b) }
  end
end

describe "Valid#gte?" do
  it "should return true if greater than" do
    Valid.gte?(2, 1).should be_true
    is(:gte?, 2, 1).should be_true
    is!(:gte?, 2, 1).should be_true

    Valid.gte?("2", "1").should be_true
    is(:gte?, "2", "1").should be_true
    is!(:gte?, "2", "1").should be_true

    Valid.gte?("", "").should be_true
    is(:gte?, "", "").should be_true
    is!(:gte?, "", "").should be_true

    Valid.gte?("b", "a").should be_true
    is(:gte?, "b", "a").should be_true
    is!(:gte?, "b", "a").should be_true

    Valid.gte?("bb", "abb").should be_true
    is(:gte?, "bb", "abb").should be_true
    is!(:gte?, "bb", "abb").should be_true

    Valid.gte?(:b, :a).should be_true
    is(:gte?, :b, :a).should be_true
    is!(:gte?, :b, :a).should be_true

    Valid.gte?(:b, :ab).should be_true
    is(:gte?, :b, :ab).should be_true
    is!(:gte?, :b, :ab).should be_true
  end

  it "should return false if not greater than" do
    Valid.gte?(1, 2).should be_false
    is(:gte?, 1, 2).should be_false
    is_error :gte? { is!(:gte?, 1, 2) }

    Valid.gte?("1", "2").should be_false
    is(:gte?, "1", "2").should be_false
    is_error :gte? { is!(:gte?, "1", "2") }

    Valid.gte?("a", "b").should be_false
    is(:gte?, "a", "b").should be_false
    is_error :gte? { is!(:gte?, "a", "b") }

    Valid.gte?("abb", "bb").should be_false
    is(:gte?, "abb", "bb").should be_false
    is_error :gte? { is!(:gte?, "abb", "bb") }

    Valid.gte?(:a, :b).should be_false
    is(:gte?, :a, :b).should be_false
    is_error :gte? { is!(:gte?, :a, :b) }

    Valid.gte?(:ab, :b).should be_false
    is(:gte?, :ab, :b).should be_false
    is_error :gte? { is!(:gte?, :ab, :b) }
  end

  # --------------------------------------------------------------------------#

  it "should return true if equality" do
    Valid.gte?(1, 1).should be_true
    is(:gte?, 1, 1).should be_true
    is!(:gte?, 1, 1).should be_true

    Valid.gte?("", "").should be_true
    is(:gte?, "", "").should be_true
    is!(:gte?, "", "").should be_true

    Valid.gte?("ok", "ok").should be_true
    is(:gte?, "ok", "ok").should be_true
    is!(:gte?, "ok", "ok").should be_true

    Valid.gte?(:ok, :ok).should be_true
    is(:gte?, :ok, :ok).should be_true
    is!(:gte?, :ok, :ok).should be_true
  end
end

describe "Valid#lt?" do
  it "should return true if lesser than" do
    Valid.lt?(1, 2).should be_true
    is(:lt?, 1, 2).should be_true
    is!(:lt?, 1, 2).should be_true

    Valid.lt?("1", "2").should be_true
    is(:lt?, "1", "2").should be_true
    is!(:lt?, "1", "2").should be_true

    Valid.lt?("", "1").should be_true
    is(:lt?, "", "1").should be_true
    is!(:lt?, "", "1").should be_true

    Valid.lt?("a", "b").should be_true
    is(:lt?, "a", "b").should be_true
    is!(:lt?, "a", "b").should be_true

    Valid.lt?("abb", "bb").should be_true
    is(:lt?, "abb", "bb").should be_true
    is!(:lt?, "abb", "bb").should be_true

    Valid.lt?(:a, :b).should be_true
    is(:lt?, :a, :b).should be_true
    is!(:lt?, :a, :b).should be_true

    Valid.lt?(:ab, :b).should be_true
    is(:lt?, :ab, :b).should be_true
    is!(:lt?, :ab, :b).should be_true
  end

  it "should return false if not lesser than" do
    Valid.lt?(2, 1).should be_false
    is(:lt?, 2, 1).should be_false
    is_error :lt? { is!(:lt?, 2, 1) }

    Valid.lt?("2", "1").should be_false
    is(:lt?, "2", "1").should be_false
    is_error :lt? { is!(:lt?, "2", "1") }

    Valid.lt?("", "").should be_false
    is(:lt?, "", "").should be_false
    is_error :lt? { is!(:lt?, "", "") }

    Valid.lt?("b", "a").should be_false
    is(:lt?, "b", "a").should be_false
    is_error :lt? { is!(:lt?, "b", "a") }

    Valid.lt?("bb", "abb").should be_false
    is(:lt?, "bb", "abb").should be_false
    is_error :lt? { is!(:lt?, "bb", "abb") }

    Valid.lt?(:b, :a).should be_false
    is(:lt?, :b, :a).should be_false
    is_error :lt? { is!(:lt?, :b, :a) }

    Valid.lt?(:b, :ab).should be_false
    is(:lt?, :b, :ab).should be_false
    is_error :lt? { is!(:lt?, :b, :ab) }
  end
end

describe "Valid#lte?" do
  it "should return true if lesser than" do
    Valid.lte?(1, 2).should be_true
    is(:lte?, 1, 2).should be_true
    is!(:lte?, 1, 2).should be_true

    Valid.lte?("1", "2").should be_true
    is(:lte?, "1", "2").should be_true
    is!(:lte?, "1", "2").should be_true

    Valid.lte?("", "").should be_true
    is(:lte?, "", "").should be_true
    is!(:lte?, "", "").should be_true

    Valid.lte?("a", "b").should be_true
    is(:lte?, "a", "b").should be_true
    is!(:lte?, "a", "b").should be_true

    Valid.lte?("abb", "bb").should be_true
    is(:lte?, "abb", "bb").should be_true
    is!(:lte?, "abb", "bb").should be_true

    Valid.lte?(:a, :b).should be_true
    is(:lte?, :a, :b).should be_true
    is!(:lte?, :a, :b).should be_true

    Valid.lte?(:ab, :b).should be_true
    is(:lte?, :ab, :b).should be_true
    is!(:lte?, :ab, :b).should be_true
  end

  it "should return false if not lesser than" do
    Valid.lte?(2, 1).should be_false
    is(:lte?, 2, 1).should be_false
    is_error :lte? { is!(:lte?, 2, 1) }

    Valid.lte?("2", "1").should be_false
    is(:lte?, "2", "1").should be_false
    is_error :lte? { is!(:lte?, "2", "1") }

    Valid.lte?("2", "").should be_false
    is(:lte?, "2", "").should be_false
    is_error :lte? { is!(:lte?, "2", "") }

    Valid.lte?("b", "a").should be_false
    is(:lte?, "b", "a").should be_false
    is_error :lte? { is!(:lte?, "b", "a") }

    Valid.lte?("bb", "abb").should be_false
    is(:lte?, "bb", "abb").should be_false
    is_error :lte? { is!(:lte?, "bb", "abb") }

    Valid.lte?(:b, :a).should be_false
    is(:lte?, :b, :a).should be_false
    is_error :lte? { is!(:lte?, :b, :a) }

    Valid.lte?(:b, :ab).should be_false
    is(:lte?, :b, :ab).should be_false
    is_error :lte? { is!(:lte?, :b, :ab) }
  end

  # --------------------------------------------------------------------------#

  it "should return true if equality" do
    Valid.lte?(1, 1).should be_true
    is(:lte?, 1, 1).should be_true
    is!(:lte?, 1, 1).should be_true

    Valid.lte?("", "").should be_true
    is(:lte?, "", "").should be_true
    is!(:lte?, "", "").should be_true

    Valid.lte?("ok", "ok").should be_true
    is(:lte?, "ok", "ok").should be_true
    is!(:lte?, "ok", "ok").should be_true

    Valid.lte?(:ok, :ok).should be_true
    is(:lte?, :ok, :ok).should be_true
    is!(:lte?, :ok, :ok).should be_true
  end

  it "should return false if inequality" do
    Valid.lte?(2, 1).should be_false
    is(:lte?, 2, 1).should be_false
    is_error :lte? { is!(:lte?, 2, 1) }
  end
end

describe "Valid#min?" do
  it "should return true if greater than" do
    Valid.min?(2, 1).should be_true
    is(:min?, 2, 1).should be_true
    is!(:min?, 2, 1).should be_true

    Valid.min?("2", "1").should be_true
    is(:min?, "2", "1").should be_true
    is!(:min?, "2", "1").should be_true

    Valid.min?("b", "a").should be_true
    is(:min?, "b", "a").should be_true
    is!(:min?, "b", "a").should be_true

    Valid.min?("bb", "abb").should be_true
    is(:min?, "bb", "abb").should be_true
    is!(:min?, "bb", "abb").should be_true

    Valid.min?(:b, :a).should be_true
    is(:min?, :b, :a).should be_true
    is!(:min?, :b, :a).should be_true

    Valid.min?(:b, :ab).should be_true
    is(:min?, :b, :ab).should be_true
    is!(:min?, :b, :ab).should be_true
  end

  it "should return false if not greater than" do
    Valid.min?(1, 2).should be_false
    is(:min?, 1, 2).should be_false
    is_error :min? { is!(:min?, 1, 2) }

    Valid.min?("1", "2").should be_false
    is(:min?, "1", "2").should be_false
    is_error :min? { is!(:min?, "1", "2") }

    Valid.min?("a", "b").should be_false
    is(:min?, "a", "b").should be_false
    is_error :min? { is!(:min?, "a", "b") }

    Valid.min?("abb", "bb").should be_false
    is(:min?, "abb", "bb").should be_false
    is_error :min? { is!(:min?, "abb", "bb") }

    Valid.min?(:a, :b).should be_false
    is(:min?, :a, :b).should be_false
    is_error :min? { is!(:min?, :a, :b) }

    Valid.min?(:ab, :b).should be_false
    is(:min?, :ab, :b).should be_false
    is_error :min? { is!(:min?, :ab, :b) }
  end

  # --------------------------------------------------------------------------#

  it "should return true if equality" do
    Valid.min?(1, 1).should be_true
    is(:min?, 1, 1).should be_true
    is!(:min?, 1, 1).should be_true

    Valid.min?("", "").should be_true
    is(:min?, "", "").should be_true
    is!(:min?, "", "").should be_true

    Valid.min?("ok", "ok").should be_true
    is(:min?, "ok", "ok").should be_true
    is!(:min?, "ok", "ok").should be_true

    Valid.min?(:ok, :ok).should be_true
    is(:min?, :ok, :ok).should be_true
    is!(:min?, :ok, :ok).should be_true
  end
end

describe "Valid#max?" do
  it "should return true if lesser than" do
    Valid.max?(1, 2).should be_true
    is(:max?, 1, 2).should be_true
    is!(:max?, 1, 2).should be_true

    Valid.max?("1", "2").should be_true
    is(:max?, "1", "2").should be_true
    is!(:max?, "1", "2").should be_true

    Valid.max?("a", "b").should be_true
    is(:max?, "a", "b").should be_true
    is!(:max?, "a", "b").should be_true

    Valid.max?("abb", "bb").should be_true
    is(:max?, "abb", "bb").should be_true
    is!(:max?, "abb", "bb").should be_true

    Valid.max?(:a, :b).should be_true
    is(:max?, :a, :b).should be_true
    is!(:max?, :a, :b).should be_true

    Valid.max?(:ab, :b).should be_true
    is(:max?, :ab, :b).should be_true
    is!(:max?, :ab, :b).should be_true
  end

  it "should return false if not lesser than" do
    Valid.max?(2, 1).should be_false
    is(:max?, 2, 1).should be_false
    is_error :max? { is!(:max?, 2, 1) }

    Valid.max?("2", "1").should be_false
    is(:max?, "2", "1").should be_false
    is_error :max? { is!(:max?, "2", "1") }

    Valid.max?("b", "a").should be_false
    is(:max?, "b", "a").should be_false
    is_error :max? { is!(:max?, "b", "a") }

    Valid.max?("bb", "abb").should be_false
    is(:max?, "bb", "abb").should be_false
    is_error :max? { is!(:max?, "bb", "abb") }

    Valid.max?(:b, :a).should be_false
    is(:max?, :b, :a).should be_false
    is_error :max? { is!(:max?, :b, :a) }

    Valid.max?(:b, :ab).should be_false
    is(:max?, :b, :ab).should be_false
    is_error :max? { is!(:max?, :b, :ab) }
  end

  # --------------------------------------------------------------------------#

  it "should return true if equality" do
    Valid.max?(1, 1).should be_true
    is(:max?, 1, 1).should be_true
    is!(:max?, 1, 1).should be_true

    Valid.max?("", "").should be_true
    is(:max?, "", "").should be_true
    is!(:max?, "", "").should be_true

    Valid.max?("ok", "ok").should be_true
    is(:max?, "ok", "ok").should be_true
    is!(:max?, "ok", "ok").should be_true

    Valid.max?(:ok, :ok).should be_true
    is(:max?, :ok, :ok).should be_true
    is!(:max?, :ok, :ok).should be_true
  end
end

describe "Valid#between?" do
  it "should return true if between" do
    Valid.between?(11, 10, 20).should be_true
    is(:between?, 11, 10, 20).should be_true
    is!(:between?, 11, 10, 20).should be_true

    Valid.between?("11", "10", "20").should be_true
    is(:between?, "11", "10", "20").should be_true
    is!(:between?, "11", "10", "20").should be_true

    Valid.between?("b", "a", "c").should be_true
    is(:between?, "b", "a", "c").should be_true
    is!(:between?, "b", "a", "c").should be_true

    Valid.between?("abc", "abb", "bb").should be_true
    is(:between?, "abc", "abb", "bb").should be_true
    is!(:between?, "abc", "abb", "bb").should be_true

    Valid.between?(:b, :a, :c).should be_true
    is(:between?, :b, :a, :c).should be_true
    is!(:between?, :b, :a, :c).should be_true

    Valid.between?(:abc, :a, :b).should be_true
    is(:between?, :abc, :a, :b).should be_true
    is!(:between?, :abc, :a, :b).should be_true
  end

  it "should return false if not between" do
    Valid.between?(1, 2, 4).should be_false
    is(:between?, 1, 2, 4).should be_false
    is_error :between? { is!(:between?, 1, 2, 4) }

    Valid.between?(5, 2, 4).should be_false
    is(:between?, 5, 2, 4).should be_false
    is_error :between? { is!(:between?, 5, 2, 4) }

    Valid.between?("1", "2", "4").should be_false
    is(:between?, "1", "2", "4").should be_false
    is_error :between? { is!(:between?, "1", "2", "4") }

    Valid.between?("5", "2", "4").should be_false
    is(:between?, "5", "2", "4").should be_false
    is_error :between? { is!(:between?, "5", "2", "4") }

    Valid.between?("e", "b", "d").should be_false
    is(:between?, "e", "b", "d").should be_false
    is_error :between? { is!(:between?, "e", "b", "d") }

    Valid.between?("a", "b", "d").should be_false
    is(:between?, "a", "b", "d").should be_false
    is_error :between? { is!(:between?, "a", "b", "d") }

    Valid.between?("ab", "abb", "bb").should be_false
    is(:between?, "ab", "abb", "bb").should be_false
    is_error :between? { is!(:between?, "ab", "abb", "bb") }

    Valid.between?("bbc", "abb", "bb").should be_false
    is(:between?, "bbc", "abb", "bb").should be_false
    is_error :between? { is!(:between?, "bbc", "abb", "bb") }

    Valid.between?(:a, :b, :d).should be_false
    is(:between?, :a, :b, :d).should be_false
    is_error :between? { is!(:between?, :a, :b, :d) }

    Valid.between?(:e, :b, :d).should be_false
    is(:between?, :e, :b, :d).should be_false
    is_error :between? { is!(:between?, :e, :b, :d) }

    Valid.between?(:ab, :abb, :bb).should be_false
    is(:between?, :ab, :abb, :bb).should be_false
    is_error :between? { is!(:between?, :ab, :abb, :bb) }

    Valid.between?(:bbc, :abb, :bb).should be_false
    is(:between?, :bbc, :abb, :bb).should be_false
    is_error :between? { is!(:between?, :bbc, :abb, :bb) }
  end

  # --------------------------------------------------------------------------#

  it "should return true if equality" do
    Valid.between?(10, 10, 20).should be_true
    is(:between?, 10, 10, 20).should be_true
    is!(:between?, 10, 10, 20).should be_true

    Valid.between?(20, 10, 20).should be_true
    is(:between?, 20, 10, 20).should be_true
    is!(:between?, 20, 10, 20).should be_true

    Valid.between?("10", "10", "20").should be_true
    is(:between?, "10", "10", "20").should be_true
    is!(:between?, "10", "10", "20").should be_true

    Valid.between?("20", "10", "20").should be_true
    is(:between?, "20", "10", "20").should be_true
    is!(:between?, "20", "10", "20").should be_true

    Valid.between?("a", "a", "c").should be_true
    is(:between?, "a", "a", "c").should be_true
    is!(:between?, "a", "a", "c").should be_true

    Valid.between?("c", "a", "c").should be_true
    is(:between?, "c", "a", "c").should be_true
    is!(:between?, "c", "a", "c").should be_true

    Valid.between?("abb", "abb", "bb").should be_true
    is(:between?, "abb", "abb", "bb").should be_true
    is!(:between?, "abb", "abb", "bb").should be_true

    Valid.between?("bb", "abb", "bb").should be_true
    is(:between?, "bb", "abb", "bb").should be_true
    is!(:between?, "bb", "abb", "bb").should be_true

    Valid.between?(:a, :a, :c).should be_true
    is(:between?, :a, :a, :c).should be_true
    is!(:between?, :a, :a, :c).should be_true

    Valid.between?(:c, :a, :c).should be_true
    is(:between?, :c, :a, :c).should be_true
    is!(:between?, :c, :a, :c).should be_true
  end
end

describe "Valid#size?" do
  context "Int" do
    it "should return true if size is equal" do
      Valid.size?("10", 2).should be_true
      is(:size?, "10", 2).should be_true
      is!(:size?, "10", 2).should be_true

      arr = [1, 2, 3]
      Valid.size?(arr, 3).should be_true
      is(:size?, arr, 3).should be_true
      is!(:size?, arr, 3).should be_true

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, 2).should be_true
      is(:size?, hash, 2).should be_true
      is!(:size?, hash, 2).should be_true

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, 3).should be_true
      is(:size?, tuple, 3).should be_true
      is!(:size?, tuple, 3).should be_true

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, 3).should be_true
      is(:size?, namedTuple, 3).should be_true
      is!(:size?, namedTuple, 3).should be_true
    end

    it "should return false if size is not equal" do
      Valid.size?("10", 1).should be_false
      is(:size?, "10", 1).should be_false
      is_error :size? { is!(:size?, "10", 1) }

      arr = [1, 2, 3]
      Valid.size?(arr, 2).should be_false
      is(:size?, arr, 2).should be_false
      is_error :size? { is!(:size?, arr, 2) }

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, 1).should be_false
      is(:size?, hash, 1).should be_false
      is_error :size? { is!(:size?, hash, 1) }

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, 4).should be_false
      is(:size?, tuple, 4).should be_false
      is_error :size? { is!(:size?, tuple, 4) }

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, 2).should be_false
      is(:size?, namedTuple, 2).should be_false
      is_error :size? { is!(:size?, namedTuple, 2) }
    end
  end

  context "String" do
    it "should return true if size is equal" do
      Valid.size?("10", "2").should be_true
      is(:size?, "10", "2").should be_true
      is!(:size?, "10", "2").should be_true

      arr = [1, 2, 3]
      Valid.size?(arr, "3").should be_true
      is(:size?, arr, "3").should be_true
      is!(:size?, arr, "3").should be_true

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, "2").should be_true
      is(:size?, hash, "2").should be_true
      is!(:size?, hash, "2").should be_true

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, "3").should be_true
      is(:size?, tuple, "3").should be_true
      is!(:size?, tuple, "3").should be_true

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, "3").should be_true
      is(:size?, namedTuple, "3").should be_true
      is!(:size?, namedTuple, "3").should be_true
    end

    it "should return false if size is not equal" do
      Valid.size?("10", "1").should be_false
      is(:size?, "10", "1").should be_false
      is_error :size? { is!(:size?, "10", "1") }

      arr = [1, 2, 3]
      Valid.size?(arr, "2").should be_false
      is(:size?, arr, "2").should be_false
      is_error :size? { is!(:size?, arr, "2") }

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, "1").should be_false
      is(:size?, hash, "1").should be_false
      is_error :size? { is!(:size?, hash, "1") }

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, "4").should be_false
      is(:size?, tuple, "4").should be_false
      is_error :size? { is!(:size?, tuple, "4") }

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, "2").should be_false
      is(:size?, namedTuple, "2").should be_false
      is_error :size? { is!(:size?, namedTuple, "2") }
    end
  end

  context "Array(Int)" do
    it "should return true if size is equal" do
      Valid.size?("10", [2]).should be_true
      is(:size?, "10", [2]).should be_true
      is!(:size?, "10", [2]).should be_true

      Valid.size?("10", [2, 3]).should be_true
      is(:size?, "10", [2, 3]).should be_true
      is!(:size?, "10", [2, 3]).should be_true

      arr = [1, 2, 3]
      Valid.size?(arr, [3]).should be_true
      is(:size?, arr, [3]).should be_true
      is!(:size?, arr, [3]).should be_true

      Valid.size?(arr, [2, 3]).should be_true
      is(:size?, arr, [2, 3]).should be_true
      is!(:size?, arr, [2, 3]).should be_true

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, [2]).should be_true
      is(:size?, hash, [2]).should be_true
      is!(:size?, hash, [2]).should be_true

      Valid.size?(hash, [2, 3]).should be_true
      is(:size?, hash, [2, 3]).should be_true
      is!(:size?, hash, [2, 3]).should be_true

      Valid.size?(hash, [0, 2, 3]).should be_true
      is(:size?, hash, [0, 2, 3]).should be_true
      is!(:size?, hash, [0, 2, 3]).should be_true

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, [3]).should be_true
      is(:size?, tuple, [3]).should be_true
      is!(:size?, tuple, [3]).should be_true

      Valid.size?(tuple, [2, 3]).should be_true
      is(:size?, tuple, [2, 3]).should be_true
      is!(:size?, tuple, [2, 3]).should be_true

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, [3]).should be_true
      is(:size?, namedTuple, [3]).should be_true
      is!(:size?, namedTuple, [3]).should be_true

      Valid.size?(namedTuple, [3, 2]).should be_true
      is(:size?, namedTuple, [3, 2]).should be_true
      is!(:size?, namedTuple, [3, 2]).should be_true
    end

    it "should return false if size is not equal" do
      Valid.size?("10", [1]).should be_false
      is(:size?, "10", [1]).should be_false
      is_error :size? { is!(:size?, "10", [1]) }

      Valid.size?("10", [1, 3]).should be_false
      is(:size?, "10", [1, 3]).should be_false
      is_error :size? { is!(:size?, "10", [1, 3]) }

      arr = [1, 2, 3]
      Valid.size?(arr, [2]).should be_false
      is(:size?, arr, [2]).should be_false
      is_error :size? { is!(:size?, arr, [2]) }

      Valid.size?(arr, [2, 4]).should be_false
      is(:size?, arr, [2, 4]).should be_false
      is_error :size? { is!(:size?, arr, [2, 4]) }

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, [1]).should be_false
      is(:size?, hash, [1]).should be_false
      is_error :size? { is!(:size?, hash, [1]) }

      Valid.size?(hash, [1, 3]).should be_false
      is(:size?, hash, [1, 3]).should be_false
      is_error :size? { is!(:size?, hash, [1, 3]) }

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, [4]).should be_false
      is(:size?, tuple, [4]).should be_false
      is_error :size? { is!(:size?, tuple, [4]) }

      Valid.size?(tuple, [1, 4]).should be_false
      is(:size?, tuple, [1, 4]).should be_false
      is_error :size? { is!(:size?, tuple, [1, 4]) }

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, [2]).should be_false
      is(:size?, namedTuple, [2]).should be_false
      is_error :size? { is!(:size?, namedTuple, [2]) }

      Valid.size?(namedTuple, [2, 4]).should be_false
      is(:size?, namedTuple, [2, 4]).should be_false
      is_error :size? { is!(:size?, namedTuple, [2, 4]) }
    end
  end

  context "Array(String)" do
    it "should return true if size is equal" do
      Valid.size?("10", ["2"]).should be_true
      is(:size?, "10", ["2"]).should be_true
      is!(:size?, "10", ["2"]).should be_true

      Valid.size?("10", ["2", "3"]).should be_true
      is(:size?, "10", ["2", "3"]).should be_true
      is!(:size?, "10", ["2", "3"]).should be_true

      arr = [1, 2, 3]
      Valid.size?(arr, ["3"]).should be_true
      is(:size?, arr, ["3"]).should be_true
      is!(:size?, arr, ["3"]).should be_true

      Valid.size?(arr, ["2", "3"]).should be_true
      is(:size?, arr, ["2", "3"]).should be_true
      is!(:size?, arr, ["2", "3"]).should be_true

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, ["2"]).should be_true
      is(:size?, hash, ["2"]).should be_true
      is!(:size?, hash, ["2"]).should be_true

      Valid.size?(hash, ["2", "3"]).should be_true
      is(:size?, hash, ["2", "3"]).should be_true
      is!(:size?, hash, ["2", "3"]).should be_true

      Valid.size?(hash, ["0", "2", "3"]).should be_true
      is(:size?, hash, ["0", "2", "3"]).should be_true
      is!(:size?, hash, ["0", "2", "3"]).should be_true

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, ["3"]).should be_true
      is(:size?, tuple, ["3"]).should be_true
      is!(:size?, tuple, ["3"]).should be_true

      Valid.size?(tuple, ["2", "3"]).should be_true
      is(:size?, tuple, ["2", "3"]).should be_true
      is!(:size?, tuple, ["2", "3"]).should be_true

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, ["3"]).should be_true
      is(:size?, namedTuple, ["3"]).should be_true
      is!(:size?, namedTuple, ["3"]).should be_true

      Valid.size?(namedTuple, ["3", "2"]).should be_true
      is(:size?, namedTuple, ["3", "2"]).should be_true
      is!(:size?, namedTuple, ["3", "2"]).should be_true
    end

    it "should return false if size is not equal" do
      Valid.size?("10", ["1"]).should be_false
      is(:size?, "10", ["1"]).should be_false
      is_error :size? { is!(:size?, "10", ["1"]) }

      Valid.size?("10", ["1", "3"]).should be_false
      is(:size?, "10", ["1", "3"]).should be_false
      is_error :size? { is!(:size?, "10", ["1", "3"]) }

      arr = [1, 2, 3]
      Valid.size?(arr, ["2"]).should be_false
      is(:size?, arr, ["2"]).should be_false
      is_error :size? { is!(:size?, arr, ["2"]) }

      Valid.size?(arr, ["2", "4"]).should be_false
      is(:size?, arr, ["2", "4"]).should be_false
      is_error :size? { is!(:size?, arr, ["2", "4"]) }

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, ["1"]).should be_false
      is(:size?, hash, ["1"]).should be_false
      is_error :size? { is!(:size?, hash, ["1"]) }

      Valid.size?(hash, ["1", "3"]).should be_false
      is(:size?, hash, ["1", "3"]).should be_false
      is_error :size? { is!(:size?, hash, ["1", "3"]) }

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, ["4"]).should be_false
      is(:size?, tuple, ["4"]).should be_false
      is_error :size? { is!(:size?, tuple, ["4"]) }

      Valid.size?(tuple, ["1", "4"]).should be_false
      is(:size?, tuple, ["1", "4"]).should be_false
      is_error :size? { is!(:size?, tuple, ["1", "4"]) }

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, ["2"]).should be_false
      is(:size?, namedTuple, ["2"]).should be_false
      is_error :size? { is!(:size?, namedTuple, ["2"]) }

      Valid.size?(namedTuple, ["2", "4"]).should be_false
      is(:size?, namedTuple, ["2", "4"]).should be_false
      is_error :size? { is!(:size?, namedTuple, ["2", "4"]) }
    end
  end

  context "Range" do
    it "should return true if size is equal" do
      Valid.size?("10", 2..4).should be_true
      is(:size?, "10", 2..4).should be_true
      is!(:size?, "10", 2..4).should be_true

      Valid.size?("10", 1..2).should be_true
      is(:size?, "10", 1..2).should be_true
      is!(:size?, "10", 1..2).should be_true

      Valid.size?("10", 1..3).should be_true
      is(:size?, "10", 1..3).should be_true
      is!(:size?, "10", 1..3).should be_true

      arr = [1, 2, 3]
      Valid.size?(arr, 3..10).should be_true
      is(:size?, arr, 3..10).should be_true
      is!(:size?, arr, 3..10).should be_true

      Valid.size?(arr, 1..3).should be_true
      is(:size?, arr, 1..3).should be_true
      is!(:size?, arr, 1..3).should be_true

      Valid.size?(arr, 1..10).should be_true
      is(:size?, arr, 1..10).should be_true
      is!(:size?, arr, 1..10).should be_true

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, 2..4).should be_true
      is(:size?, hash, 2..4).should be_true
      is!(:size?, hash, 2..4).should be_true

      Valid.size?(hash, 0..2).should be_true
      is(:size?, hash, 0..2).should be_true
      is!(:size?, hash, 0..2).should be_true

      Valid.size?(hash, 0..4).should be_true
      is(:size?, hash, 0..4).should be_true
      is!(:size?, hash, 0..4).should be_true

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, 3..6).should be_true
      is(:size?, tuple, 3..6).should be_true
      is!(:size?, tuple, 3..6).should be_true

      Valid.size?(tuple, 1..3).should be_true
      is(:size?, tuple, 1..3).should be_true
      is!(:size?, tuple, 1..3).should be_true

      Valid.size?(tuple, 0..4).should be_true
      is(:size?, tuple, 0..4).should be_true
      is!(:size?, tuple, 0..4).should be_true

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, 3..10).should be_true
      is(:size?, namedTuple, 3..10).should be_true
      is!(:size?, namedTuple, 3..10).should be_true

      Valid.size?(namedTuple, 0..3).should be_true
      is(:size?, namedTuple, 0..3).should be_true
      is!(:size?, namedTuple, 0..3).should be_true

      Valid.size?(namedTuple, 1..4).should be_true
      is(:size?, namedTuple, 1..4).should be_true
      is!(:size?, namedTuple, 1..4).should be_true
    end

    it "should return false if size is not equal" do
      Valid.size?("10", 0..1).should be_false
      is(:size?, "10", 0..1).should be_false
      is_error :size? { is!(:size?, "10", 0..1) }

      Valid.size?("10", 3...5).should be_false
      is(:size?, "10", 3...5).should be_false
      is_error :size? { is!(:size?, "10", 3...5) }

      arr = [1, 2, 3]
      Valid.size?(arr, 0...3).should be_false
      is(:size?, arr, 0...3).should be_false
      is_error :size? { is!(:size?, arr, 0...3) }

      Valid.size?(arr, 4..10).should be_false
      is(:size?, arr, 4..10).should be_false
      is_error :size? { is!(:size?, arr, 4..10) }

      hash = {"one" => 1, "two" => 2}
      Valid.size?(hash, 0...2).should be_false
      is(:size?, hash, 0...2).should be_false
      is_error :size? { is!(:size?, hash, 0...2) }

      Valid.size?(hash, 3..5).should be_false
      is(:size?, hash, 3..5).should be_false
      is_error :size? { is!(:size?, hash, 3..5) }

      tuple = {1, "hello", 'x'}
      Valid.size?(tuple, 4..6).should be_false
      is(:size?, tuple, 4..6).should be_false
      is_error :size? { is!(:size?, tuple, 4..6) }

      Valid.size?(tuple, 0..2).should be_false
      is(:size?, tuple, 0..2).should be_false
      is_error :size? { is!(:size?, tuple, 0..2) }

      namedTuple = {name: "Valid", year: 2020, dad: "Nicolas Talle"}
      Valid.size?(namedTuple, 0...3).should be_false
      is(:size?, namedTuple, 0...3).should be_false
      is_error :size? { is!(:size?, namedTuple, 0...3) }

      Valid.size?(namedTuple, 4..6).should be_false
      is(:size?, namedTuple, 4..6).should be_false
      is_error :size? { is!(:size?, namedTuple, 4..6) }
    end
  end
end
