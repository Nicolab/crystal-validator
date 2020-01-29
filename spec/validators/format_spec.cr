# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#time?" do
  it "should return true if time" do
    Valid.time?("00:00:00").should be_true
    is(:time?, "00:00:00").should be_true
    is!(:time?, "00:00:00").should be_true

    Valid.time?("01:01:01").should be_true
    is(:time?, "01:01:01").should be_true
    is!(:time?, "01:01:01").should be_true

    Valid.time?("23:59:59").should be_true
    is(:time?, "23:59:59").should be_true
    is!(:time?, "23:59:59").should be_true
  end

  it "should return false if not time" do
    Valid.time?("").should be_false
    is(:time?, "").should be_false
    is_error :time? { is!(:time?, "") }

    Valid.time?(" ").should be_false
    is(:time?, " ").should be_false
    is_error :time? { is!(:time?, " ") }

    Valid.time?("00.00.00").should be_false
    is(:time?, "00.00.00").should be_false
    is_error :time? { is!(:time?, "00.00.00") }

    Valid.time?("0:0:0").should be_false
    is(:time?, "0:0:0").should be_false
    is_error :time? { is!(:time?, "0:0:0") }

    Valid.time?("25:00:00").should be_false
    is(:time?, "25:00:00").should be_false
    is_error :time? { is!(:time?, "25:00:00") }

    Valid.time?("30:00:00").should be_false
    is(:time?, "30:00:00").should be_false
    is_error :time? { is!(:time?, "30:00:00") }

    Valid.time?("23:61:00").should be_false
    is(:time?, "23:61:00").should be_false
    is_error :time? { is!(:time?, "23:61:00") }

    Valid.time?("00:00:61").should be_false
    is(:time?, "00:00:61").should be_false
    is_error :time? { is!(:time?, "00:00:61") }

    Valid.time?("00:00:00:00").should be_false
    is(:time?, "00:00:00:00").should be_false
    is_error :time? { is!(:time?, "00:00:00:00") }

    Valid.time?("0:00:00").should be_false
    is(:time?, "0:00:00").should be_false
    is_error :time? { is!(:time?, "000:00:00") }

    Valid.time?("00:00:000").should be_false
    is(:time?, "00:00:000").should be_false
    is_error :time? { is!(:time?, "00:00:000") }

    Valid.time?("00:000:00").should be_false
    is(:time?, "00:000:00").should be_false
    is_error :time? { is!(:time?, "00:000:00") }

    Valid.time?("000:00:00").should be_false
    is(:time?, "000:00:00").should be_false
    is_error :time? { is!(:time?, "000:00:00") }

    Valid.time?("00").should be_false
    is(:time?, "00").should be_false
    is_error :time? { is!(:time?, "00") }

    Valid.time?("00:00").should be_false
    is(:time?, "00:00").should be_false
    is_error :time? { is!(:time?, "00:00") }

    Valid.time?("00:00:").should be_false
    is(:time?, "00:00:").should be_false
    is_error :time? { is!(:time?, "00:00:") }

    Valid.time?("00:00:0").should be_false
    is(:time?, "00:00:0").should be_false
    is_error :time? { is!(:time?, "00:00:0") }

    Valid.time?("aa:aa:aa").should be_false
    is(:time?, "aa:aa:aa").should be_false
    is_error :time? { is!(:time?, "aa:aa:aa") }

    Valid.time?("01::01:01").should be_false
    is(:time?, "01::01:01").should be_false
    is_error :time? { is!(:time?, "01::01:01") }

    Valid.time?("01:01::01").should be_false
    is(:time?, "01:01::01").should be_false
    is_error :time? { is!(:time?, "01:01::01") }
  end
end

describe "Valid#ascii_only?" do
  it "should return true if ascii_only" do
    Valid.ascii_only?("hello").should be_true
    is(:ascii_only?, "hello").should be_true
    is!(:ascii_only?, "hello").should be_true

    Valid.ascii_only?("").should be_true
    is(:ascii_only?, "").should be_true
    is!(:ascii_only?, "").should be_true
  end

  it "should return false if not ascii_only" do
    Valid.ascii_only?("幸せで無料").should be_false
    is(:ascii_only?, "幸せで無料").should be_false
    is_error :ascii_only? { is!(:ascii_only?, "幸せで無料") }
  end
end

describe "Valid#md5?" do
  it "should return true if md5" do
    Valid.md5?("5e9b13ce8f6c99f3f510756be58d15fe").should be_true
    is(:md5?, "5e9b13ce8f6c99f3f510756be58d15fe").should be_true
    is!(:md5?, "5e9b13ce8f6c99f3f510756be58d15fe").should be_true
  end

  it "should return false if not md5" do
    Valid.md5?("").should be_false
    is(:md5?, "").should be_false
    is_error :md5? { is!(:md5?, "") }

    Valid.md5?("5z9b13ce8f6c99f3f510756be58d15fe").should be_false
    is(:md5?, "5z9b13ce8f6c99f3f510756be58d15fe").should be_false
    is_error :md5? { is!(:md5?, "5z9b13ce8f6c99f3f510756be58d15fe") }

    # 1 char removed
    Valid.md5?("59b13ce8f6c99f3f510756be58d15fe").should be_false
    is(:md5?, "59b13ce8f6c99f3f510756be58d15fe").should be_false
    is_error :md5? { is!(:md5?, "59b13ce8f6c99f3f510756be58d15fe") }
  end
end

describe "Valid#base64?" do
  it "should return true if base64" do
    Valid.base64?("Tmljb2xhcw==").should be_true
    is(:base64?, "Tmljb2xhcw==").should be_true
    is!(:base64?, "Tmljb2xhcw==").should be_true
  end

  it "should return false if not base64" do
    Valid.base64?("").should be_false
    is(:base64?, "").should be_false
    is_error :base64? { is!(:base64?, "") }

    Valid.base64?("Tmljb2xhcw===").should be_false
    is(:base64?, "Tmljb2xhcw===").should be_false
    is_error :base64? { is!(:base64?, "Tmljb2xhcw===") }

    Valid.base64?("Tmljb2-xhcw==").should be_false
    is(:base64?, "Tmljb2-xhcw==").should be_false
    is_error :base64? { is!(:base64?, "Tmljb2-xhcw==") }
  end
end

describe "Valid#jwt?" do
  it "should return true if JWT" do
    jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIx\
    MjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.\
    SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

    Valid.jwt?(jwt).should be_true
    is(:jwt?, jwt).should be_true
    is!(:jwt?, jwt).should be_true
  end

  it "should return false if it's not JWT" do
    Valid.jwt?("").should be_false
    is(:jwt?, "").should be_false
    is_error :jwt? { is!(:jwt?, "") }

    jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIx
    MjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.
    SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

    Valid.jwt?(jwt).should be_false
    is(:jwt?, jwt).should be_false
    is_error :jwt? { is!(:jwt?, jwt) }

    jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIx\
    MjM0NTY3ODkwIiwibmFtZSI6I.kpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.\
    SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

    Valid.jwt?(jwt).should be_false
    is(:jwt?, jwt).should be_false
    is_error :jwt? { is!(:jwt?, jwt) }

    Valid.jwt?("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9").should be_false
    is(:jwt?, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9").should be_false
    is_error :jwt? { is!(:jwt?, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9") }

    Valid.jwt?("$Zs.ewu.su84").should be_false
    is(:jwt?, "$Zs.ewu.su84").should be_false
    is_error :jwt? { is!(:jwt?, "$Zs.ewu.su84") }

    Valid.jwt?("ks64$S/9.dy$§kz.3sd73b").should be_false
    is(:jwt?, "ks64$S/9.dy$§kz.3sd73b").should be_false
    is_error :jwt? { is!(:jwt?, "ks64$S/9.dy$§kz.3sd73b") }
  end
end

describe "Valid#uuid?" do
  context "v0: all" do
    it "should return true if UUID" do
      # default version (0)
      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3").should be_true
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3").should be_true
      is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3").should be_true

      Valid.uuid?("A987FBC9-4BED-4078-8F07-9141BA07C9F3").should be_true
      is(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3").should be_true
      is!(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3").should be_true

      Valid.uuid?("A987FBC9-4BED-5078-AF07-9141BA07C9F3").should be_true
      is(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3").should be_true
      is!(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3").should be_true

      # version 0 (all)
      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3", 0).should be_true
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 0).should be_true
      is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 0).should be_true

      Valid.uuid?("A987FBC9-4BED-4078-8F07-9141BA07C9F3", 0).should be_true
      is(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 0).should be_true
      is!(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 0).should be_true

      Valid.uuid?("A987FBC9-4BED-5078-AF07-9141BA07C9F3", 0).should be_true
      is(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 0).should be_true
      is!(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 0).should be_true
    end

    it "should return false if not UUID" do
      Valid.uuid?("").should be_false
      is(:uuid?, "").should be_false
      is_error :uuid? { is!(:uuid?, "") }

      Valid.uuid?("", 0).should be_false
      is(:uuid?, "", 0).should be_false
      is_error :uuid? { is!(:uuid?, "", 0) }

      Valid.uuid?("xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 0).should be_false
      is(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 0).should be_false
      is_error :uuid? { is!(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 0) }

      Valid.uuid?("xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3").should be_false
      is(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3").should be_false
      is_error :uuid? { is!(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3") }

      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx").should be_false
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx").should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx") }

      Valid.uuid?("A987FBC94BED3078CF079141BA07C9F3").should be_false
      is(:uuid?, "A987FBC94BED3078CF079141BA07C9F3").should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC94BED3078CF079141BA07C9F3") }

      Valid.uuid?("934859").should be_false
      is(:uuid?, "934859").should be_false
      is_error :uuid? { is!(:uuid?, "934859") }

      Valid.uuid?("987FBC9-4BED-3078-CF07A-9141BA07C9F3").should be_false
      is(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3").should be_false
      is_error :uuid? { is!(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3") }

      Valid.uuid?("AAAAAAAA-1111-1111-AAAG-111111111111").should be_false
      is(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111").should be_false
      is_error :uuid? { is!(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111") }
    end
  end

  context "v3" do
    it "should return true if UUID" do
      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3", 3).should be_true
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 3).should be_true
      is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 3).should be_true
    end

    it "should return false if not UUID" do
      # generic
      Valid.uuid?("", 3).should be_false
      is(:uuid?, "", 3).should be_false
      is_error :uuid? { is!(:uuid?, "", 3) }

      Valid.uuid?("xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 3).should be_false
      is(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 3).should be_false
      is_error :uuid? { is!(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 3) }

      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 3).should be_false
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 3).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 3) }

      Valid.uuid?("A987FBC94BED3078CF079141BA07C9F3", 3).should be_false
      is(:uuid?, "A987FBC94BED3078CF079141BA07C9F3", 3).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC94BED3078CF079141BA07C9F3", 3) }

      Valid.uuid?("934859", 3).should be_false
      is(:uuid?, "934859", 3).should be_false
      is_error :uuid? { is!(:uuid?, "934859", 3) }

      Valid.uuid?("987FBC9-4BED-3078-CF07A-9141BA07C9F3", 3).should be_false
      is(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3", 3).should be_false
      is_error :uuid? { is!(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3", 3) }

      Valid.uuid?("AAAAAAAA-1111-1111-AAAG-111111111111", 3).should be_false
      is(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111", 3).should be_false
      is_error :uuid? { is!(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111", 3) }

      # version specific
      # v4
      Valid.uuid?("A987FBC9-4BED-4078-8F07-9141BA07C9F3", 3).should be_false
      is(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 3).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 3) }

      # v5
      Valid.uuid?("A987FBC9-4BED-5078-AF07-9141BA07C9F3", 3).should be_false
      is(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 3).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 3) }
    end
  end

  context "v4" do
    it "should return true if UUID" do
      Valid.uuid?("A987FBC9-4BED-4078-8F07-9141BA07C9F3", 4).should be_true
      is(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 4).should be_true
      is!(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 4).should be_true
    end

    it "should return false if not UUID" do
      # generic
      Valid.uuid?("", 4).should be_false
      is(:uuid?, "", 4).should be_false
      is_error :uuid? { is!(:uuid?, "", 4) }

      Valid.uuid?("xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 4).should be_false
      is(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 4).should be_false
      is_error :uuid? { is!(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 4) }

      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 4).should be_false
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 4).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 4) }

      Valid.uuid?("A987FBC94BED3078CF079141BA07C9F3", 4).should be_false
      is(:uuid?, "A987FBC94BED3078CF079141BA07C9F3", 4).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC94BED3078CF079141BA07C9F3", 4) }

      Valid.uuid?("934859", 4).should be_false
      is(:uuid?, "934859", 4).should be_false
      is_error :uuid? { is!(:uuid?, "934859", 4) }

      Valid.uuid?("987FBC9-4BED-3078-CF07A-9141BA07C9F3", 4).should be_false
      is(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3", 4).should be_false
      is_error :uuid? { is!(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3", 4) }

      Valid.uuid?("AAAAAAAA-1111-1111-AAAG-111111111111", 4).should be_false
      is(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111", 4).should be_false
      is_error :uuid? { is!(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111", 4) }

      # version specific
      # v3
      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3", 4).should be_false
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 4).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 4) }

      # v5
      Valid.uuid?("A987FBC9-4BED-5078-AF07-9141BA07C9F3", 4).should be_false
      is(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 4).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 4) }
    end
  end

  context "v5" do
    it "should return true if UUID" do
      Valid.uuid?("A987FBC9-4BED-5078-AF07-9141BA07C9F3", 5).should be_true
      is(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 5).should be_true
      is!(:uuid?, "A987FBC9-4BED-5078-AF07-9141BA07C9F3", 5).should be_true
    end

    it "should return false if not UUID" do
      # generic
      Valid.uuid?("", 5).should be_false
      is(:uuid?, "", 5).should be_false
      is_error :uuid? { is!(:uuid?, "", 5) }

      Valid.uuid?("xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 5).should be_false
      is(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 5).should be_false
      is_error :uuid? { is!(:uuid?, "xxxA987FBC9-4BED-3078-CF07-9141BA07C9F3", 5) }

      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 5).should be_false
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 5).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3xxx", 5) }

      Valid.uuid?("A987FBC94BED3078CF079141BA07C9F3", 5).should be_false
      is(:uuid?, "A987FBC94BED3078CF079141BA07C9F3", 5).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC94BED3078CF079141BA07C9F3", 5) }

      Valid.uuid?("934859", 5).should be_false
      is(:uuid?, "934859", 5).should be_false
      is_error :uuid? { is!(:uuid?, "934859", 5) }

      Valid.uuid?("987FBC9-4BED-3078-CF07A-9141BA07C9F3", 5).should be_false
      is(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3", 5).should be_false
      is_error :uuid? { is!(:uuid?, "987FBC9-4BED-3078-CF07A-9141BA07C9F3", 5) }

      Valid.uuid?("AAAAAAAA-1111-1111-AAAG-111111111111", 5).should be_false
      is(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111", 5).should be_false
      is_error :uuid? { is!(:uuid?, "AAAAAAAA-1111-1111-AAAG-111111111111", 5) }

      # version specific
      # v3
      Valid.uuid?("A987FBC9-4BED-3078-CF07-9141BA07C9F3", 5).should be_false
      is(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 5).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-3078-CF07-9141BA07C9F3", 5) }

      # v4
      Valid.uuid?("A987FBC9-4BED-4078-8F07-9141BA07C9F3", 5).should be_false
      is(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 5).should be_false
      is_error :uuid? { is!(:uuid?, "A987FBC9-4BED-4078-8F07-9141BA07C9F3", 5) }
    end
  end
end

describe "Valid#hex?" do
  it "should return true if hexadecimal" do
    Valid.hex?("0041").should be_true
    is(:hex?, "0041").should be_true
    is!(:hex?, "0041").should be_true

    Valid.hex?("deadBEEF").should be_true
    is(:hex?, "deadBEEF").should be_true
    is!(:hex?, "deadBEEF").should be_true

    Valid.hex?("ff0044").should be_true
    is(:hex?, "ff0044").should be_true
    is!(:hex?, "ff0044").should be_true

    Valid.hex?("0xff0044").should be_true
    is(:hex?, "0xff0044").should be_true
    is!(:hex?, "0xff0044").should be_true

    Valid.hex?("0XfF0044").should be_true
    is(:hex?, "0XfF0044").should be_true
    is!(:hex?, "0XfF0044").should be_true

    Valid.hex?("0x0123456789abcDEF").should be_true
    is(:hex?, "0x0123456789abcDEF").should be_true
    is!(:hex?, "0x0123456789abcDEF").should be_true

    Valid.hex?("0X0123456789abcDEF").should be_true
    is(:hex?, "0X0123456789abcDEF").should be_true
    is!(:hex?, "0X0123456789abcDEF").should be_true

    Valid.hex?("0hfedCBA9876543210").should be_true
    is(:hex?, "0hfedCBA9876543210").should be_true
    is!(:hex?, "0hfedCBA9876543210").should be_true

    Valid.hex?("0HfedCBA9876543210").should be_true
    is(:hex?, "0HfedCBA9876543210").should be_true
    is!(:hex?, "0HfedCBA9876543210").should be_true

    Valid.hex?("0123456789abcDEF").should be_true
    is(:hex?, "0123456789abcDEF").should be_true
    is!(:hex?, "0123456789abcDEF").should be_true

    # Bytes
    Valid.hex?("0123456789abcDEF".to_slice).should be_true
    is(:hex?, "0123456789abcDEF".to_slice).should be_true
    is!(:hex?, "0123456789abcDEF".to_slice).should be_true
  end

  it "should return false if not hexadecimal" do
    Valid.hex?("").should be_false
    is(:hex?, "").should be_false
    is_error :hex? { is!(:hex?, "") }

    Valid.hex?(" ").should be_false
    is(:hex?, " ").should be_false
    is_error :hex? { is!(:hex?, " ") }

    Valid.hex?("..").should be_false
    is(:hex?, "..").should be_false
    is_error :hex? { is!(:hex?, "..") }

    Valid.hex?("abcdefg").should be_false
    is(:hex?, "abcdefg").should be_false
    is_error :hex? { is!(:hex?, "abcdefg") }

    Valid.hex?("0xa2h").should be_false
    is(:hex?, "0xa2h").should be_false
    is_error :hex? { is!(:hex?, "0xa2h") }

    Valid.hex?("0xa20x").should be_false
    is(:hex?, "0xa20x").should be_false
    is_error :hex? { is!(:hex?, "0xa20x") }

    Valid.hex?("0x0123456789abcDEFq").should be_false
    is(:hex?, "0x0123456789abcDEFq").should be_false
    is_error :hex? { is!(:hex?, "0x0123456789abcDEFq") }

    Valid.hex?("0hfedCBA9876543210q").should be_false
    is(:hex?, "0hfedCBA9876543210q").should be_false
    is_error :hex? { is!(:hex?, "0hfedCBA9876543210q") }

    Valid.hex?("01234q56789abcDEF").should be_false
    is(:hex?, "01234q56789abcDEF").should be_false
    is_error :hex? { is!(:hex?, "01234q56789abcDEF") }

    # Bytes
    Valid.hex?("01234q56789abcDEF".to_slice).should be_false
    is(:hex?, "01234q56789abcDEF".to_slice).should be_false
    is_error :hex? { is!(:hex?, "01234q56789abcDEF".to_slice) }
  end
end

describe "Valid#hex_color?" do
  it "should return true if hex_color" do
    Valid.hex_color?("#ff0000ff").should be_true
    is(:hex_color?, "#ff0000ff").should be_true
    is!(:hex_color?, "#ff0000ff").should be_true

    Valid.hex_color?("#ff0034").should be_true
    is(:hex_color?, "#ff0034").should be_true
    is!(:hex_color?, "#ff0034").should be_true

    Valid.hex_color?("#CCCCCC").should be_true
    is(:hex_color?, "#CCCCCC").should be_true
    is!(:hex_color?, "#CCCCCC").should be_true

    Valid.hex_color?("#cccccc").should be_true
    is(:hex_color?, "#cccccc").should be_true
    is!(:hex_color?, "#cccccc").should be_true

    Valid.hex_color?("0f38").should be_true
    is(:hex_color?, "0f38").should be_true
    is!(:hex_color?, "0f38").should be_true

    Valid.hex_color?("fff").should be_true
    is(:hex_color?, "fff").should be_true
    is!(:hex_color?, "fff").should be_true

    Valid.hex_color?("#f00").should be_true
    is(:hex_color?, "#f00").should be_true
    is!(:hex_color?, "#f00").should be_true
  end

  it "should return false if not hex_color" do
    Valid.hex_color?("").should be_false
    is(:hex_color?, "").should be_false
    is_error :hex_color? { is!(:hex_color?, "") }

    Valid.hex_color?(" ").should be_false
    is(:hex_color?, " ").should be_false
    is_error :hex_color? { is!(:hex_color?, " ") }

    Valid.hex_color?("#ff").should be_false
    is(:hex_color?, "#ff").should be_false
    is_error :hex_color? { is!(:hex_color?, "#ff") }

    Valid.hex_color?("fff0a").should be_false
    is(:hex_color?, "fff0a").should be_false
    is_error :hex_color? { is!(:hex_color?, "fff0a") }

    Valid.hex_color?("#ff12FG").should be_false
    is(:hex_color?, "#ff12FG").should be_false
    is_error :hex_color? { is!(:hex_color?, "#ff12FG") }

    Valid.hex_color?("gff0a").should be_false
    is(:hex_color?, "gff0a").should be_false
    is_error :hex_color? { is!(:hex_color?, "gff0a") }

    Valid.hex_color?("gff").should be_false
    is(:hex_color?, "gff").should be_false
    is_error :hex_color? { is!(:hex_color?, "gff") }

    Valid.hex_color?("-1ff").should be_false
    is(:hex_color?, "-1ff").should be_false
    is_error :hex_color? { is!(:hex_color?, "-1ff") }
  end
end

describe "Valid#mongo_id?" do
  it "should return true if mongo_id" do
    Valid.mongo_id?("507f1f77bcf86cd799439011").should be_true
    is(:mongo_id?, "507f1f77bcf86cd799439011").should be_true
    is!(:mongo_id?, "507f1f77bcf86cd799439011").should be_true
  end

  it "should return false if not mongo_id" do
    Valid.mongo_id?("").should be_false
    is(:mongo_id?, "").should be_false
    is_error :mongo_id? { is!(:mongo_id?, "") }

    Valid.mongo_id?("507f1f77bcf86cd7994390").should be_false
    is(:mongo_id?, "507f1f77bcf86cd7994390").should be_false
    is_error :mongo_id? { is!(:mongo_id?, "507f1f77bcf86cd7994390") }

    Valid.mongo_id?("507f1f77bcf86cd79943901z").should be_false
    is(:mongo_id?, "507f1f77bcf86cd79943901z").should be_false
    is_error :mongo_id? { is!(:mongo_id?, "507f1f77bcf86cd79943901z") }

    Valid.mongo_id?("507g1f77bcf86cd799439011").should be_false
    is(:mongo_id?, "507g1f77bcf86cd799439011").should be_false
    is_error :mongo_id? { is!(:mongo_id?, "507g1f77bcf86cd799439011") }
  end
end
