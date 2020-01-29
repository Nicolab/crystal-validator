# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#lat_lng?" do
  it "should return true if lat_lng" do
    Valid.lat_lng?("(-17.738223, 85.605469)").should be_true
    is(:lat_lng?, "(-17.738223, 85.605469)").should be_true
    is!(:lat_lng?, "(-17.738223, 85.605469)").should be_true

    Valid.lat_lng?("(-12.3456789, +12.3456789)").should be_true
    is(:lat_lng?, "(-12.3456789, +12.3456789)").should be_true
    is!(:lat_lng?, "(-12.3456789, +12.3456789)").should be_true

    Valid.lat_lng?("(-60.978437, -0.175781)").should be_true
    is(:lat_lng?, "(-60.978437, -0.175781)").should be_true
    is!(:lat_lng?, "(-60.978437, -0.175781)").should be_true

    Valid.lat_lng?("(77.719772, -37.529297)").should be_true
    is(:lat_lng?, "(77.719772, -37.529297)").should be_true
    is!(:lat_lng?, "(77.719772, -37.529297)").should be_true

    Valid.lat_lng?("(7.264394, 165.058594)").should be_true
    is(:lat_lng?, "(7.264394, 165.058594)").should be_true
    is!(:lat_lng?, "(7.264394, 165.058594)").should be_true

    Valid.lat_lng?("0.955766, -19.863281").should be_true
    is(:lat_lng?, "0.955766, -19.863281").should be_true
    is!(:lat_lng?, "0.955766, -19.863281").should be_true

    Valid.lat_lng?("(31.269161,164.355469)").should be_true
    is(:lat_lng?, "(31.269161,164.355469)").should be_true
    is!(:lat_lng?, "(31.269161,164.355469)").should be_true

    Valid.lat_lng?("+12.3456789, -12.3456789").should be_true
    is(:lat_lng?, "+12.3456789, -12.3456789").should be_true
    is!(:lat_lng?, "+12.3456789, -12.3456789").should be_true

    Valid.lat_lng?("-15.379543, -137.285156").should be_true
    is(:lat_lng?, "-15.379543, -137.285156").should be_true
    is!(:lat_lng?, "-15.379543, -137.285156").should be_true

    Valid.lat_lng?("(11.770570, -162.949219)").should be_true
    is(:lat_lng?, "(11.770570, -162.949219)").should be_true
    is!(:lat_lng?, "(11.770570, -162.949219)").should be_true

    Valid.lat_lng?("-55.034319, 113.027344").should be_true
    is(:lat_lng?, "-55.034319, 113.027344").should be_true
    is!(:lat_lng?, "-55.034319, 113.027344").should be_true

    Valid.lat_lng?("58.025555, 36.738281").should be_true
    is(:lat_lng?, "58.025555, 36.738281").should be_true
    is!(:lat_lng?, "58.025555, 36.738281").should be_true

    Valid.lat_lng?("55.720923,-28.652344").should be_true
    is(:lat_lng?, "55.720923,-28.652344").should be_true
    is!(:lat_lng?, "55.720923,-28.652344").should be_true

    Valid.lat_lng?("-90.00000,-180.00000").should be_true
    is(:lat_lng?, "-90.00000,-180.00000").should be_true
    is!(:lat_lng?, "-90.00000,-180.00000").should be_true

    Valid.lat_lng?("(-71, -146)").should be_true
    is(:lat_lng?, "(-71, -146)").should be_true
    is!(:lat_lng?, "(-71, -146)").should be_true

    Valid.lat_lng?("(-71.616864, -146.616864)").should be_true
    is(:lat_lng?, "(-71.616864, -146.616864)").should be_true
    is!(:lat_lng?, "(-71.616864, -146.616864)").should be_true

    Valid.lat_lng?("-0.55, +0.22").should be_true
    is(:lat_lng?, "-0.55, +0.22").should be_true
    is!(:lat_lng?, "-0.55, +0.22").should be_true

    Valid.lat_lng?("90, 180").should be_true
    is(:lat_lng?, "90, 180").should be_true
    is!(:lat_lng?, "90, 180").should be_true

    Valid.lat_lng?("+90, -180").should be_true
    is(:lat_lng?, "+90, -180").should be_true
    is!(:lat_lng?, "+90, -180").should be_true

    Valid.lat_lng?("-90,+180").should be_true
    is(:lat_lng?, "-90,+180").should be_true
    is!(:lat_lng?, "-90,+180").should be_true

    Valid.lat_lng?("90,180").should be_true
    is(:lat_lng?, "90,180").should be_true
    is!(:lat_lng?, "90,180").should be_true

    Valid.lat_lng?("0,0").should be_true
    is(:lat_lng?, "0,0").should be_true
    is!(:lat_lng?, "0,0").should be_true

    Valid.lat_lng?("0, 0").should be_true
    is(:lat_lng?, "0, 0").should be_true
    is!(:lat_lng?, "0, 0").should be_true
  end

  it "should return false if not lat_lng" do
    Valid.lat_lng?("").should be_false
    is(:lat_lng?, "").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "") }

    Valid.lat_lng?(" ").should be_false
    is(:lat_lng?, " ").should be_false
    is_error :lat_lng? { is!(:lat_lng?, " ") }

    Valid.lat_lng?(",").should be_false
    is(:lat_lng?, ",").should be_false
    is_error :lat_lng? { is!(:lat_lng?, ",") }

    Valid.lat_lng?("(,)").should be_false
    is(:lat_lng?, "(,)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(,)") }

    Valid.lat_lng?("+,-").should be_false
    is(:lat_lng?, "+,-").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "+,-") }

    Valid.lat_lng?("0.955766, -19.863281)").should be_false
    is(:lat_lng?, "0.955766, -19.863281)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "0.955766, -19.863281)") }

    Valid.lat_lng?("(-17.738223, 85.605469").should be_false
    is(:lat_lng?, "(-17.738223, 85.605469").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-17.738223, 85.605469") }

    Valid.lat_lng?("+90.1, -180.1").should be_false
    is(:lat_lng?, "+90.1, -180.1").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "+90.1, -180.1") }

    Valid.lat_lng?("-90., -180.").should be_false
    is(:lat_lng?, "-90., -180.").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-90., -180.") }

    Valid.lat_lng?("-112.96381, -160.96381").should be_false
    is(:lat_lng?, "-112.96381, -160.96381").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-112.96381, -160.96381") }

    Valid.lat_lng?("-112, -160").should be_false
    is(:lat_lng?, "-112, -160").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-112, -160") }

    Valid.lat_lng?("-116.894222, -126.894222").should be_false
    is(:lat_lng?, "-116.894222, -126.894222").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-116.894222, -126.894222") }

    Valid.lat_lng?("-116, -126").should be_false
    is(:lat_lng?, "-116, -126").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-116, -126") }

    Valid.lat_lng?("(-120.969949, +203.969949)").should be_false
    is(:lat_lng?, "(-120.969949, +203.969949)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-120.969949, +203.969949)") }

    Valid.lat_lng?("-110.369532, 223.369532").should be_false
    is(:lat_lng?, "-110.369532, 223.369532").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-110.369532, 223.369532") }

    Valid.lat_lng?("(-110, -223)").should be_false
    is(:lat_lng?, "(-110, -223)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-110, -223)") }

    Valid.lat_lng?("+119.821728, -196.821728").should be_false
    is(:lat_lng?, "+119.821728, -196.821728").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "+119.821728, -196.821728") }

    Valid.lat_lng?("(-119, -196)").should be_false
    is(:lat_lng?, "(-119, -196)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-119, -196)") }

    Valid.lat_lng?("(-120, -203)").should be_false
    is(:lat_lng?, "(-120, -203)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-120, -203)") }

    Valid.lat_lng?("(-137.5942, -148.5942)").should be_false
    is(:lat_lng?, "(-137.5942, -148.5942)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-137.5942, -148.5942)") }

    Valid.lat_lng?("137, -148").should be_false
    is(:lat_lng?, "137, -148").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "137, -148") }

    Valid.lat_lng?("137,-148").should be_false
    is(:lat_lng?, "137,-148").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "137,-148") }

    Valid.lat_lng?("-95.738043, -96.738043-95.738043, -96.738043").should be_false
    is(:lat_lng?, "-95.738043, -96.738043").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-95.738043, -96.738043") }

    Valid.lat_lng?("-95, -96").should be_false
    is(:lat_lng?, "-95, -96").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "-95, -96") }

    Valid.lat_lng?("(-126.400010, -158.400010)").should be_false
    is(:lat_lng?, "(-126.400010, -158.400010)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(-126.400010, -158.400010)") }

    Valid.lat_lng?("126, -158").should be_false
    is(:lat_lng?, "126, -158").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "126, -158") }

    Valid.lat_lng?("090.0000, 0180.0000").should be_false
    is(:lat_lng?, "090.0000, 0180.0000").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "090.0000, 0180.0000") }

    Valid.lat_lng?("+90.000000, -180.00001").should be_false
    is(:lat_lng?, "+90.000000, -180.00001").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "+90.000000, -180.00001") }

    Valid.lat_lng?("90.1000000, 180.000000").should be_false
    is(:lat_lng?, "90.1000000, 180.000000").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "90.1000000, 180.000000") }

    Valid.lat_lng?("89.9999999989, 360.0000000").should be_false
    is(:lat_lng?, "89.9999999989, 360.0000000").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "89.9999999989, 360.0000000") }

    Valid.lat_lng?("(020.000000, 010.000000000)").should be_false
    is(:lat_lng?, "(020.000000, 010.000000000)").should be_false
    is_error :lat_lng? { is!(:lat_lng?, "(020.000000, 010.000000000)") }
  end
end
