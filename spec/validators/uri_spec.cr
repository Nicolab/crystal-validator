# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "../spec_helper"

describe "Valid#domain?" do
  it "should return true if domain" do
    Valid.domain?("nicolab.net").should be_true
    is(:domain?, "nicolab.net").should be_true
    is!(:domain?, "nicolab.net").should be_true

    Valid.domain?("en.wikipedia.org").should be_true
    is(:domain?, "en.wikipedia.org").should be_true
    is!(:domain?, "en.wikipedia.org").should be_true
  end

  it "should return false if not domain" do
    Valid.domain?("https://nicolab.net").should be_false
    is(:domain?, "https://nicolab.net").should be_false
    is_error :domain? { is!(:domain?, "https://nicolab.net") }

    Valid.domain?("gitter.im/crystal-lang").should be_false
    is(:domain?, "gitter.im/crystal-lang").should be_false
    is_error :domain? { is!(:domain?, "gitter.im/crystal-lang") }
  end
end

describe "Valid#port?" do
  it "should return true if port" do
    Valid.port?(1).should be_true
    is(:port?, 1).should be_true
    is!(:port?, 1).should be_true

    Valid.port?("1").should be_true
    is(:port?, "1").should be_true
    is!(:port?, "1").should be_true

    Valid.port?(65535).should be_true
    is(:port?, 65535).should be_true
    is!(:port?, 65535).should be_true

    Valid.port?("65535").should be_true
    is(:port?, "65535").should be_true
    is!(:port?, "65535").should be_true

    Valid.port?(443).should be_true
    is(:port?, 443).should be_true
    is!(:port?, 443).should be_true

    Valid.port?(443, 443, 445).should be_true
    is(:port?, 443, 443, 445).should be_true
    is!(:port?, 443, 443, 445).should be_true

    Valid.port?(444, 443, 445).should be_true
    is(:port?, 444, 443, 445).should be_true
    is!(:port?, 444, 443, 445).should be_true

    Valid.port?(445, 443, 445).should be_true
    is(:port?, 445, 443, 445).should be_true
    is!(:port?, 445, 443, 445).should be_true

    Valid.port?("444", "443", "445").should be_true
    is(:port?, "444", "443", "445").should be_true
    is!(:port?, "444", "443", "445").should be_true
  end

  it "should return false if not port" do
    # Dynamic port
    Valid.port?(0).should be_false
    is(:port?, 0).should be_false
    is_error :port? { is!(:port?, 0) }

    Valid.port?("0").should be_false
    is(:port?, "0").should be_false
    is_error :port? { is!(:port?, "0") }

    Valid.port?(65536).should be_false
    is(:port?, 65536).should be_false
    is_error :port? { is!(:port?, 65536) }

    Valid.port?("65536").should be_false
    is(:port?, "65536").should be_false
    is_error :port? { is!(:port?, "65536") }

    Valid.port?(-1).should be_false
    is(:port?, -1).should be_false
    is_error :port? { is!(:port?, -1) }

    Valid.port?("-1").should be_false
    is(:port?, "-1").should be_false
    is_error :port? { is!(:port?, "-1") }

    Valid.port?(443, 444, 446).should be_false
    is(:port?, 443, 444, 446).should be_false
    is_error :port? { is!(:port?, 443, 444, 446) }

    Valid.port?("443", "444", "446").should be_false
    is(:port?, "443", "444", "446").should be_false
    is_error :port? { is!(:port?, "443", "444", "446") }

    Valid.port?(447, 444, 446).should be_false
    is(:port?, 447, 444, 446).should be_false
    is_error :port? { is!(:port?, 447, 444, 446) }

    Valid.port?("447", "444", "446").should be_false
    is(:port?, "447", "444", "446").should be_false
    is_error :port? { is!(:port?, "447", "444", "446") }
  end
end

describe "Valid#url?" do
  it "should return true if url" do
    Valid.url?("https://nicolab.net").should be_true
    is(:url?, "https://nicolab.net").should be_true
    is!(:url?, "https://nicolab.net").should be_true

    Valid.url?("http://example.org:8080").should be_true
    is(:url?, "http://example.org:8080").should be_true
    is!(:url?, "http://example.org:8080").should be_true

    Valid.url?("https://gitter.im/crystal-lang").should be_true
    is(:url?, "https://gitter.im/crystal-lang").should be_true
    is!(:url?, "https://gitter.im/crystal-lang").should be_true

    Valid.url?("https://crystal-lang.org/reference/syntax_and_semantics/literals/named_tuple.html").should be_true
    is(:url?, "https://crystal-lang.org/reference/syntax_and_semantics/literals/named_tuple.html").should be_true
    is!(:url?, "https://crystal-lang.org/reference/syntax_and_semantics/literals/named_tuple.html").should be_true

    Valid.url?(
      "http://www.google.com/search?q=crystal+lang+validator" \
      "&oq=crystal+lang+validator&aqs=chrome..78n58o69i64l4.20810j0j1&" \
      "sourceid=chrome&ie=UTF-8"
    ).should be_true

    is(
      :url?,
      "http://www.google.com/search?q=crystal+lang+validator" \
      "&oq=crystal+lang+validator&aqs=chrome..78n58o69i64l4.20810j0j1&" \
      "sourceid=chrome&ie=UTF-8"
    ).should be_true

    is!(
      :url?,
      "http://www.google.com/search?q=crystal+lang+validator" \
      "&oq=crystal+lang+validator&aqs=chrome..78n58o69i64l4.20810j0j1&" \
      "sourceid=chrome&ie=UTF-8"
    ).should be_true

    Valid.url?("https://nicolab.#{"a" * 12}").should be_true
    is(:url?, "https://nicolab.#{"a" * 12}").should be_true
    is!(:url?, "https://nicolab.#{"a" * 12}").should be_true
  end

  it "should return false if not url" do
    Valid.url?("").should be_false
    is(:url?, "").should be_false
    is_error :url? { is!(:url?, "") }

    Valid.url?("https://nicolab").should be_false
    is(:url?, "https://nicolab").should be_false
    is_error :url? { is!(:url?, "https://nicolab") }

    Valid.url?("https://nicolab.t").should be_false
    is(:url?, "https://nicolab.t").should be_false
    is_error :url? { is!(:url?, "https://nicolab.t") }

    Valid.url?("https://nicolab.11").should be_false
    is(:url?, "https://nicolab.11").should be_false
    is_error :url? { is!(:url?, "https://nicolab.11") }

    Valid.url?("https://nicolab..net").should be_false
    is(:url?, "https://nicolab..net").should be_false
    is_error :url? { is!(:url?, "https://nicolab..net") }

    Valid.url?("https://nicolab.#{"a" * 19}").should be_false
    is(:url?, "https://nicolab.#{"a" * 19}").should be_false
    is_error :url? { is!(:url?, "https://nicolab.#{"a" * 19}") }

    Valid.url?("http://example.org:0").should be_false
    is(:url?, "http://example.org:0").should be_false
    is_error :url? { is!(:url?, "http://example.org:0") }

    Valid.url?("http://example.org:65536").should be_false
    is(:url?, "http://example.org:65536").should be_false
    is_error :url? { is!(:url?, "http://example.org:65536") }
  end
end

describe "Valid#ip?" do
  it "should return true if IP" do
    [
      "127.0.0.1",
      "0.0.0.0",
      "255.255.255.255",
      "1.2.3.4",
      "::1",
      "2001:db8:0000:1:1:1:1:1",
      "2001:41d0:2:a141::1",
      "::ffff:127.0.0.1",
      "::0000",
      "0000::",
      "1::",
      "1111:1:1:1:1:1:1:1",
      "fe80::a6db:30ff:fe98:e946",
      "::",
      "::ffff:127.0.0.1",
      "0:0:0:0:0:ffff:127.0.0.1",
    ].each do |addr|
      Valid.ip?(addr).should be_true
      is(:ip?, addr).should be_true
      is!(:ip?, addr).should be_true
    end
  end

  it "should return false if not IP" do
    [
      "abc",
      "256.0.0.0",
      "0.0.0.256",
      "26.0.0.256",
      "0200.200.200.200",
      "200.0200.200.200",
      "200.200.0200.200",
      "200.200.200.0200",
      "::banana",
      "banana::",
      "::1banana",
      "::1::",
      "1:",
      ":1",
      ":1:1:1::2",
      "1:1:1:1:1:1:1:1:1:1:1:1:1:1:1:1",
      "::11111",
      "11111:1:1:1:1:1:1:1",
      "2001:db8:0000:1:1:1:1::1",
      "0:0:0:0:0:0:ffff:127.0.0.1",
      "0:0:0:0:ffff:127.0.0.1",
    ].each do |addr|
      Valid.ip?(addr).should be_false
      is(:ip?, addr).should be_false
      is_error :ip? { is!(:ip?, addr) }
    end
  end
end

describe "Valid#ipv4?" do
  it "should return true if IPv4" do
    [
      "127.0.0.1",
      "0.0.0.0",
      "255.255.255.255",
      "1.2.3.4",
      "255.0.0.1",
      "0.0.1.1",
      "8.8.8.8",
      "198.27.92.1",
    ].each do |addr|
      Valid.ipv4?(addr).should be_true
      is(:ipv4?, addr).should be_true
      is!(:ipv4?, addr).should be_true
    end
  end

  it "should return false if not IPv4" do
    [
      "::1",
      "2001:db8:0000:1:1:1:1:1",
      "::ffff:127.0.0.1",
      "137.132.10.01",
      "0.256.0.0",
      "0.0.0.256",
      "256.255.255.255",
      "255.256.255.255",
      "255.255.256.255",
      "255.255.255.256",
      "8.8.8.8.8",
    ].each do |addr|
      Valid.ipv4?(addr).should be_false
      is(:ipv4?, addr).should be_false
      is_error :ipv4? { is!(:ipv4?, addr) }
    end
  end
end

describe "Valid#ipv6?" do
  it "should return true if IPv6" do
    [
      "::1",
      "2001:db8:0000:1:1:1:1:1",
      "::ffff:127.0.0.1",
      "fe80::1234%1",
      "ff08::9abc%10",
      "ff08::9abc%interface10",
      "ff02::5678%pvc1.3",
    ].each do |addr|
      Valid.ipv6?(addr).should be_true
      is(:ipv6?, addr).should be_true
      is!(:ipv6?, addr).should be_true
    end
  end

  it "should return false if not IPv6" do
    [
      "127.0.0.1",
      "0.0.0.0",
      "255.255.255.255",
      "1.2.3.4",
      "::ffff:287.0.0.1",
      "%",
      "fe80::1234%",
      "fe80::1234%1%3%4",
      "fe80%fe80%",
    ].each do |addr|
      Valid.ipv6?(addr).should be_false
      is(:ipv6?, addr).should be_false
      is_error :ipv6? { is!(:ipv6?, addr) }
    end
  end
end

describe "Valid#email?" do
  it "should return true if email" do
    Valid.email?("u.s-e_r@exa-mple.org").should be_true
    is(:email?, "u.s-e_r@exa-mple.org").should be_true
    is!(:email?, "u.s-e_r@exa-mple.org").should be_true

    Valid.email?("user@example.#{"o"*12}").should be_true
    is(:email?, "user@example.#{"o"*12}").should be_true
    is!(:email?, "user@example.#{"o"*12}").should be_true
  end

  it "should return false if not email" do
    Valid.email?("").should be_false
    is(:email?, "").should be_false
    is_error :email? { is!(:email?, "") }

    Valid.email?(".user@example.org").should be_false
    is(:email?, ".user@example.org").should be_false
    is_error :email? { is!(:email?, ".user@example.org") }

    Valid.email?("-user@example.org").should be_false
    is(:email?, "-user@example.org").should be_false
    is_error :email? { is!(:email?, "-user@example.org") }

    Valid.email?("_user@example.org").should be_false
    is(:email?, "_user@example.org").should be_false
    is_error :email? { is!(:email?, "_user@example.org") }

    Valid.email?("use(r)@example.org").should be_false
    is(:email?, "use(r)@example.org").should be_false
    is_error :email? { is!(:email?, "use(r)@example.org") }

    Valid.email?("u..ser@example.org").should be_false
    is(:email?, "u..ser@example.org").should be_false
    is_error :email? { is!(:email?, "u..ser@example.org") }

    Valid.email?("u--ser@example.org").should be_false
    is(:email?, "u--ser@example.org").should be_false
    is_error :email? { is!(:email?, "u--ser@example.org") }

    Valid.email?("u___ser@example.org").should be_false
    is(:email?, "u___ser@example.org").should be_false
    is_error :email? { is!(:email?, "u___ser@example.org") }

    Valid.email?("user@exam--ple.org").should be_false
    is(:email?, "user@exam--ple.org").should be_false
    is_error :email? { is!(:email?, "user@exam--ple.org") }

    Valid.email?("user@example.#{"o"*13}").should be_false
    is(:email?, "user@example.#{"o"*13}").should be_false
    is_error :email? { is!(:email?, "user@example.#{"o"*13}") }
  end
end

describe "Valid#slug?" do
  it "should return true if slug" do
    Valid.slug?("a").should be_true
    is(:slug?, "a").should be_true
    is!(:slug?, "a").should be_true

    Valid.slug?("abc", 3, 4).should be_true
    is(:slug?, "abc", 3, 4).should be_true
    is!(:slug?, "abc", 3, 4).should be_true

    Valid.slug?("check-that_is-good").should be_true
    is(:slug?, "check-that_is-good").should be_true
    is!(:slug?, "check-that_is-good").should be_true
  end

  it "should return false if not slug" do
    Valid.slug?("").should be_false
    is(:slug?, "").should be_false
    is_error :slug? { is!(:slug?, "") }

    Valid.slug?("no good").should be_false
    is(:slug?, "no good").should be_false
    is_error :slug? { is!(:slug?, "no good") }

    Valid.slug?("no/good").should be_false
    is(:slug?, "no/good").should be_false
    is_error :slug? { is!(:slug?, "no/good") }

    Valid.slug?("no@good").should be_false
    is(:slug?, "no@good").should be_false
    is_error :slug? { is!(:slug?, "no@good") }

    Valid.slug?("no.good").should be_false
    is(:slug?, "no.good").should be_false
    is_error :slug? { is!(:slug?, "no.good") }

    Valid.slug?("check-that_is-good", 1, 10).should be_false
    is(:slug?, "check-that_is-good", 1, 10).should be_false
    is_error :slug? { is!(:slug?, "check-that_is-good", 1, 10) }

    Valid.slug?("check-that_is-good", 30).should be_false
    is(:slug?, "check-that_is-good", 30).should be_false
    is_error :slug? { is!(:slug?, "check-that_is-good", 30) }
  end
end

describe "Valid#mac_addr?" do
  it "should return true if mac_addr" do
    [
      "ab:ab:ab:ab:ab:ab",
      "FF:FF:FF:FF:FF:FF",
      "01:02:03:04:05:ab",
      "01:AB:03:04:05:06",
      "A9 C5 D4 9F EB D3",
      "01 02 03 04 05 ab",
      "01-02-03-04-05-ab",
      "0102.0304.05ab",
    ].each do |addr|
      Valid.mac_addr?(addr).should be_true
      is(:mac_addr?, addr).should be_true
      is!(:mac_addr?, addr).should be_true
    end
  end

  it "should return false if not mac_addr" do
    [
      "abc",
      "01:02:03:04:05",
      "01:02:03:04::ab",
      "1:2:3:4:5:6",
      "AB:CD:EF:GH:01:02",
      "A9C5 D4 9F EB D3",
      "01-02 03:04 05 ab",
      "0102.03:04.05ab",
    ].each do |addr|
      Valid.mac_addr?(addr).should be_false
      is(:mac_addr?, addr).should be_false
      is_error :mac_addr? { is!(:mac_addr?, addr) }
    end
  end

  context "without colons" do
    it "should return true if mac_addr" do
      [
        "abababababab",
        "FFFFFFFFFFFF",
        "0102030405ab",
        "01AB03040506",
      ].each do |addr|
        Valid.mac_addr?(addr, no_colons: true).should be_true
        is(:mac_addr?, addr, true).should be_true
        is!(:mac_addr?, addr, true).should be_true
      end
    end

    it "should return false if not mac_addr" do
      [
        "abc",
        "01:02:03:04:05",
        "01:02:03:04::ab",
        "1:2:3:4:5:6",
        "AB:CD:EF:GH:01:02",
        "ab:ab:ab:ab:ab:ab",
        "FF:FF:FF:FF:FF:FF",
        "01:02:03:04:05:ab",
        "01:AB:03:04:05:06",
        "0102030405",
        "01020304ab",
        "123456",
        "ABCDEFGH0102",
      ].each do |addr|
        Valid.mac_addr?(addr, no_colons: true).should be_false
        is(:mac_addr?, addr, true).should be_false
        is_error :mac_addr? { is!(:mac_addr?, addr, true) }
      end
    end
  end
end

describe "Valid#magnet_uri?" do
  it "should return true if URI" do
    [
      "magnet:?xt=urn:btih:06E2A9683BF4DA92C73A661AC56F0ECC9C63C5B4&dn=helloword2000&tr=udp://helloworld:1337/announce",
      "magnet:?xt=urn:btih:3E30322D5BFC7444B7B1D8DD42404B75D0531DFB&dn=world&tr=udp://world.com:1337",
      "magnet:?xt=urn:btih:4ODKSDJBVMSDSNJVBCBFYFBKNRU875DW8D97DWC6&dn=helloworld&tr=udp://helloworld.com:1337",
      "magnet:?xt=urn:btih:1GSHJVBDVDVJFYEHKFHEFIO8573898434JBFEGHD&dn=foo&tr=udp://foo.com:1337",
      "magnet:?xt=urn:btih:MCJDCYUFHEUD6E2752T7UJNEKHSUGEJFGTFHVBJS&dn=bar&tr=udp://bar.com:1337",
      "magnet:?xt=urn:btih:LAKDHWDHEBFRFVUFJENBYYTEUY837562JH2GEFYH&dn=foobar&tr=udp://foobar.com:1337",
      "magnet:?xt=urn:btih:MKCJBHCBJDCU725TGEB3Y6RE8EJ2U267UNJFGUID&dn=test&tr=udp://test.com:1337",
      "magnet:?xt=urn:btih:UHWY2892JNEJ2GTEYOMDNU67E8ICGICYE92JDUGH&dn=baz&tr=udp://baz.com:1337",
      "magnet:?xt=urn:btih:HS263FG8U3GFIDHWD7829BYFCIXB78XIHG7CWCUG&dn=foz&tr=udp://foz.com:1337",
    ].each do |uri|
      Valid.magnet_uri?(uri).should be_true
      is(:magnet_uri?, uri).should be_true
      is!(:magnet_uri?, uri).should be_true
    end
  end

  it "should return false if not URI" do
    [
      "",
      ":?xt=urn:btih:06E2A9683BF4DA92C73A661AC56F0ECC9C63C5B4&dn=helloword2000&tr=udp://helloworld:1337/announce",
      "magnett:?xt=urn:btih:3E30322D5BFC7444B7B1D8DD42404B75D0531DFB&dn=world&tr=udp://world.com:1337",
      "xt=urn:btih:4ODKSDJBVMSDSNJVBCBFYFBKNRU875DW8D97DWC6&dn=helloworld&tr=udp://helloworld.com:1337",
      "magneta:?xt=urn:btih:1GSHJVBDVDVJFYEHKFHEFIO8573898434JBFEGHD&dn=foo&tr=udp://foo.com:1337",
      "magnet:?xt=uarn:btih:MCJDCYUFHEUD6E2752T7UJNEKHSUGEJFGTFHVBJS&dn=bar&tr=udp://bar.com:1337",
      "magnet:?xt=urn:btihz&dn=foobar&tr=udp://foobar.com:1337",
      "magnet:?xat=urn:btih:MKCJBHCBJDCU725TGEB3Y6RE8EJ2U267UNJFGUID&dn=test&tr=udp://test.com:1337",
      "magnet::?xt=urn:btih:UHWY2892JNEJ2GTEYOMDNU67E8ICGICYE92JDUGH&dn=baz&tr=udp://baz.com:1337",
      "magnet:?xt:btih:HS263FG8U3GFIDHWD7829BYFCIXB78XIHG7CWCUG&dn=foz&tr=udp://foz.com:1337",
    ].each do |uri|
      Valid.magnet_uri?(uri).should be_false
      is(:magnet_uri?, uri).should be_false
      is_error :magnet_uri? { is!(:magnet_uri?, uri) }
    end
  end
end
