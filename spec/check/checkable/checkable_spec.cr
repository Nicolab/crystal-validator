# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "./spec_helper"

describe "Checkable" do
  Spec.before_each {
    H::CheckableTest.reset_hooks_state
  }

  describe "#validation_rules" do
    it "should get validation rules" do
      H::BundleTest.test_validation_rules.should be_true
    end
  end

  describe "#validation_required?" do
    it "should returns true if the field is required" do
      H::BundleTest.test_validation_required_true.should be_true
    end

    it "should returns false if the field is not required" do
      H::BundleTest.test_validation_required_false.should be_true
    end
  end

  describe "#validation_nilable?" do
    it "should returns true if the field is nilable" do
      H::BundleTest.test_validation_nilable_true.should be_true
    end

    it "should returns false if the field is not nilable" do
      H::BundleTest.test_validation_nilable_false.should be_true
    end
  end

  describe "Converters Hash / JSON" do
    describe "#map_json_keys" do
      it "should get the map JSON keys" do
        map = H::BundleTest.map_json_keys
        map.should eq({"email" => "email", "age" => "age", "testCase" => "test_case"})
      end
    end

    describe "#to_crystal_h" do
      it "should get Crystal Hash (name convention) from JSON" do
        h = H::BundleTest.to_crystal_h(JSON.parse(%({"email": "false@mail.com", "age": 10, "testCase": null})).as_h)
        h.should eq({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
      end
    end

    describe "#to_json_h" do
      it "should get JSON Hash (name convention) from Crystal Hash" do
        h = H::BundleTest.to_json_h({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
        h.should eq(JSON.parse(%({"email": "false@mail.com", "age": 10, "testCase": null})).as_h)
      end
    end

    describe "#h_from_json" do
      it "should get Crystal Hash (name convention) from JSON string" do
        ok, h = H::BundleTest.h_from_json(%({"email": "false@mail.com", "age": 10, "testCase": null}))
        ok.should be_true
        h.should eq({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
      end

      it "should returns 'ok' false when JSON string is invalid (not converted to Hash)" do
        ok, h = H::BundleTest.h_from_json(%(email": "false@mail.com", "age": 10, "testCase": null}))
        ok.should be_false
        h.should be_nil
      end
    end

    describe "#h_from_json!" do
      it "should get Crystal Hash (name convention) from JSON string" do
        h = H::BundleTest.h_from_json!(%({"email": "false@mail.com", "age": 10, "testCase": null}))
        h.should eq({"email" => "false@mail.com", "age" => 10, "test_case" => nil})
      end

      it "should raise when JSON string is invalid (not converted to Hash)" do
        expect_raises(JSON::ParseException, "Unexpected char") do
          H::BundleTest.h_from_json!(%(email": false@mail.com", "age": 10, "testCase": null}))
        end
      end
    end
  end
end
