# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#null?" do
  list = get_hash

  it "should return true if null (nil)" do
    vnil = nil

    Valid.null?(vnil).should be_true
    is(:null?, vnil).should be_true
    is!(:null?, vnil).should be_true

    Valid.null?(nil).should be_true
    is(:null?, nil).should be_true
    is!(:null?, nil).should be_true

    ->(v : Int32?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    ->(v : Int32?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call vnil

    ->(v : UInt32?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    ->(v : String?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    ->(v : Bool?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    ->(v : Array(Bool)?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    ->(v : Array(Int64)?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    ->(v : Hash(Symbol, Nil | Bool)?) do
      Valid.null?(v).should be_true
      is(:null?, v).should be_true
      is!(:null?, v).should be_true
    end.call nil

    Valid.null?(list[:nil]?).should be_true
    is(:null?, list[:nil]?).should be_true
    is!(:null?, list[:nil]?).should be_true

    Valid.null?(list["nil"]?).should be_true
    is(:null?, list["nil"]?).should be_true
    is!(:null?, list["nil"]?).should be_true

    Valid.null?(list["absent"]?).should be_true
    is(:null?, list["absent"]?).should be_true
    is!(:null?, list["absent"]?).should be_true
  end

  it "should return false if not null (not nil)" do
    Valid.null?(list[:zero]?).should be_false
    is(:null?, list[:zero]?).should be_false
    is_error :null? { is!(:null?, list[:zero]?) }

    Valid.null?(list[:blank_str]?).should be_false
    is(:null?, list[:blank_str]?).should be_false
    is_error :null? { is!(:null?, list[:blank_str]?) }

    Valid.null?(list[:space]?).should be_false
    is(:null?, list[:space]?).should be_false
    is_error :null? { is!(:null?, list[:space]?) }

    Valid.null?(list[:empty_array]?).should be_false
    is(:null?, list[:empty_array]?).should be_false
    is_error :null? { is!(:null?, list[:empty_array]?) }

    ->(v : Bool?) do
      Valid.null?(v).should be_false
      is(:null?, v).should be_false
      is_error :null? { is!(:null?, v) }
    end.call false
  end
end

describe "Valid#not_null?" do
  list = get_hash

  it "should return true if not null (not nil)" do
    Valid.not_null?(list[:zero]?).should be_true
    is(:not_null?, list[:zero]?).should be_true
    is!(:not_null?, list[:zero]?).should be_true

    Valid.not_null?(list[:blank_str]?).should be_true
    is(:not_null?, list[:blank_str]?).should be_true
    is!(:not_null?, list[:blank_str]?)

    Valid.not_null?(list[:space]?).should be_true
    is(:not_null?, list[:space]?).should be_true
    is!(:not_null?, list[:space]?).should be_true

    Valid.not_null?(list[:empty_array]?).should be_true
    is(:not_null?, list[:empty_array]?).should be_true
    is!(:not_null?, list[:empty_array]?).should be_true

    ->(v : Int32?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call 0

    ->(v : UInt32?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call 0.to_u32

    ->(v : String?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call ""

    ->(v : Bool?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call true

    ->(v : Array(Bool)?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call [false]

    ->(v : Array(Int64)?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call [0.to_i64]

    ->(v : Array(Nil)?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call [nil]

    ->(v : Hash(Symbol, Nil)?) do
      Valid.not_null?(v).should be_true
      is(:not_null?, v).should be_true
      is!(:not_null?, v).should be_true
    end.call({:nil => nil})
  end

  it "should return false if null (nil)" do
    vnil = nil

    Valid.not_null?(nil).should be_false
    is(:not_null?, nil).should be_false
    is_error :not_null? { is!(:not_null?, nil) }

    Valid.not_null?(vnil).should be_false
    is(:not_null?, vnil).should be_false
    is_error :not_null? { is!(:not_null?, vnil) }

    ->(v : Int32?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call vnil

    ->(v : Int32?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : UInt32?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : String?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : Bool?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : Array(Bool)?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : Array(Int64)?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : Array(Nil)?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    ->(v : Hash(Symbol, Nil)?) do
      Valid.not_null?(v).should be_false
      is(:not_null?, v).should be_false
      is_error :not_null? { is!(:not_null?, v) }
    end.call nil

    Valid.not_null?(list[:nil]?).should be_false
    is(:not_null?, list[:nil]?).should be_false
    is_error :not_null? { is!(:not_null?, list[:nil]?) }

    Valid.not_null?(list["nil"]?).should be_false
    is(:not_null?, list["nil"]?).should be_false
    is_error :not_null? { is!(:not_null?, list["nil"]?) }

    Valid.not_null?(list["absent"]?).should be_false
    is(:not_null?, list["absent"]?).should be_false
    is_error :not_null? { is!(:not_null?, list["absent"]?) }
  end
end
