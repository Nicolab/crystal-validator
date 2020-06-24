# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  @@rx_domain_part = /(?<name>[a-z0-9]{1}[a-z0-9\.\-]*){1,63}\.(?<ext>[a-z]+)/
  @@rx_domain = /^#{@@rx_domain_part}$/
  @@rx_email = /^[a-zA-Z0-9]+[a-zA-Z0-9_\.\-]*@#{@@rx_domain_part}$/
  @@rx_url = /^http(?:s)?\:\/\/#{@@rx_domain_part}[a-zA-Z0-9:%-_\+.~#!?&\/\/=]*$/
  @@rx_magnet_uri = /^magnet\:\?xt\=urn\:[a-z0-9]+\:[a-z0-9]{32,40}\&dn\=.+\&tr\=.+/i
  @@rx_ipv4 = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
  @@rx_ipv6_block = /^[0-9A-F]{1,4}$/i

  @@rx_mac_addr = /^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$/
  @@rx_mac_addr_no_colons = /^([0-9a-fA-F]){12}$/
  @@rx_mac_addr_with_hyphen = /^([0-9a-fA-F][0-9a-fA-F]-){5}([0-9a-fA-F][0-9a-fA-F])$/
  @@rx_mac_addr_with_spaces = /^([0-9a-fA-F][0-9a-fA-F]\s){5}([0-9a-fA-F][0-9a-fA-F])$/
  @@rx_mac_addr_with_dots = /^([0-9a-fA-F]{4}).([0-9a-fA-F]{4}).([0-9a-fA-F]{4})$/ # Validates that the *value* is a domain or subdomain.

  def self.domain?(value : String) : Bool
    size = value.size
    return false if size > 75 || size < 4
    return false if value.includes?("..")
    return false unless m = value.match(@@rx_domain)

    # domain extension
    ext_size = m["ext"].size
    return false if ext_size < 2 || ext_size > 12

    true
  end

  # Validates that the *value* is in a valid port range,
  # between (inclusive) 1 / *min* and 65535 / *max*.
  def self.port?(value = 0, min = 1, max = 65535) : Bool
    return false unless self.between? value, 1, 65535
    self.between? value, min, max
  end

  # :ditto:
  def self.port?(value : String = "0",
                 min : String = "1",
                 max : String = "65535") : Bool
    return false unless self.number?(min) && self.number?(max)
    self.port? value.to_i, min.to_i, max.to_i
  end

  # Validates that the *value* is a URL.
  def self.url?(value : String) : Bool
    size = value.size

    if size >= 2083 ||
       size < 11 ||
       value.match(/[\s<>]/) ||
       value.starts_with?("mailto:")
      return false
    end

    return false unless m = value.match(@@rx_url)
    return false unless self.domain? "#{m["name"]}.#{m["ext"]}"

    # Validates the port if it's there
    sp = value.gsub(/^http(?:s)?:\/\//, "").split(":")

    if sp.size > 1
      return true unless m_port = sp[1].match(/^[0-9]+/)
      return self.port? m_port[0]
    end

    true
  end

  # Validates that the *value* is an IP (IPv4 or IPv6).
  def self.ip?(value : String) : Bool
    self.ipv4?(value) || self.ipv6?(value)
  end

  # Validates that the *value* is an IPv4.
  def self.ipv4?(value : String) : Bool
    !value.match(@@rx_ipv4).nil?
  end

  # Validates that the *value* is an IPv6.
  def self.ipv6?(value : String) : Bool
    addr_and_zone = [value]

    # ipv6 addresses could have scoped architecture
    # according to https://tools.ietf.org/html/rfc4007#section-11
    if value.includes?('%')
      addr_and_zone = value.split('%')

      # it must be just two parts
      return false unless addr_and_zone.size == 2

      # the first part must be the address
      return false unless addr_and_zone[0].includes?(':')

      # the second part must not be empty
      return false if addr_and_zone[1] == ""
    end

    blocks = addr_and_zone[0].split(':')

    # marker to indicate ::
    found_omission_block = false

    # At least some OS accept the last 32 bits of an IPv6 address
    # (i.e. 2 of the blocks) in IPv4 notation, and RFC 3493 says
    # that '::ffff:a.b.c.d' is valid for IPv4-mapped IPv6 addresses,
    # and '::a.b.c.d' is deprecated, but also valid.
    found_ipv4_transition_block = self.ipv4?(blocks[blocks.size - 1])
    expected_number_of_blocks = found_ipv4_transition_block ? 7 : 8

    return false if blocks.size > expected_number_of_blocks

    # initial or final ::
    return true if value == "::"

    if value[0...2] == "::"
      blocks.shift 2
      found_omission_block = true
    elsif value[(value.size - 2)..] == "::"
      blocks.pop 2
      found_omission_block = true
    end

    i = 0
    while i < blocks.size
      # test for a :: which can not be at the string start/end
      # since those cases have been handled above
      if blocks[i] === "" && i > 0 && i < blocks.size - 1
        # multiple :: in address
        return false if found_omission_block
        found_omission_block = true

        # if it has not been checked before that the last
        # if block is a valid IPv4 address
      elsif !(found_ipv4_transition_block && i == blocks.size - 1) &&
            blocks[i].match(@@rx_ipv6_block).nil?
        return false
      end

      i += 1
    end

    return blocks.size >= 1 if found_omission_block
    blocks.size == expected_number_of_blocks
  end

  # Validates that the *value* is an email.
  # This method is stricter than the standard allows.
  # It is subjectively based on the common addresses
  # of organisations (@enterprise.ltd, ...)
  # and mail services suck as Gmail, Hotmail, Yahoo !, ...
  def self.email?(value : String) : Bool
    size = value.size

    return false if size > 60 || size < 7
    return false if value.includes?("..")
    return false if value.includes?("--")
    return false if value.includes?("___")
    return false unless m = value.match(@@rx_email)

    self.domain? "#{m["name"]}.#{m["ext"]}"
  end

  # Validates that the *value* is a slug.
  def self.slug?(value : String, min = 1, max = 100) : Bool
    !value.match(/^([a-zA-Z0-9_-]{#{min},#{max}})$/).nil?
  end

  # Validates that the *value* is a MAC address.
  def self.mac_addr?(value : String, no_colons : Bool = false) : Bool
    return !value.match(@@rx_mac_addr_no_colons).nil? if no_colons

    !value.match(@@rx_mac_addr).nil? ||
      !value.match(@@rx_mac_addr_with_hyphen).nil? ||
      !value.match(@@rx_mac_addr_with_spaces).nil? ||
      !value.match(@@rx_mac_addr_with_dots).nil?
  end

  # Validates that the *value* is a Magnet URI.
  def self.magnet_uri?(value : String) : Bool
    !value.match(@@rx_magnet_uri).nil?
  end
end
