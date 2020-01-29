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

# describe "Valid#ip?" do
#   it "should return true if IP" do
#   end

#   it "should return false if not IP" do
#   end
# end

# describe "Valid#ipv4?" do
#   it "should return true if IPv4" do
#   end

#   it "should return false if not IPv4" do
#   end
# end

# describe "Valid#ipv6?" do
#   it "should return true if IPv6" do
#   end

#   it "should return false if not IPv6" do
#   end
# end

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

# describe "Valid#mac_addr?" do
#   it "should return true if mac_addr" do
#   end

#   it "should return false if not mac_addr" do
#   end
# end

# describe "Valid#magnet_uri?" do
#   it "should return true if URI" do
#   end

#   it "should return false if not URI" do
#   end
# end
