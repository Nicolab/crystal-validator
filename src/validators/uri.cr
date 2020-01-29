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
  @@rx_magnet_uri = /^magnet:\?xt=urn:[a-z0-9]+:[a-z0-9]{32,40}&dn=.+&tr=.+$/i

  # Validates that the *value* is a domain or subdomain.
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

  # TODO: Validates that the *value* is an IP (IPv4 or IPv6).
  def self.ip?(value : String) : Bool
    self.ipv4?(value) || self.ipv6?(value)
  end

  # TODO: Validates that the *value* is an IPv4.
  def self.ipv4?(value : String) : Bool
    raise NotImplementedError.new "ipv4"
  end

  # TODO: Validates that the *value* is an IPv6.
  def self.ipv6?(value : String) : Bool
    raise NotImplementedError.new "ipv6"
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
    return self.domain? "#{m["name"]}.#{m["ext"]}"
  end

  # Validates that the *value* is a slug.
  def self.slug?(value : String, min = 1, max = 100) : Bool
    !value.match(/^([a-zA-Z0-9_-]{#{min},#{max}})$/).nil?
  end

  # TODO: Validates that the *value* is a MAC address.
  def self.mac_addr?(value : String) : Bool
    raise NotImplementedError.new "mac_addr"
  end

  # TODO: Validates that the *value* is a Magnet URI.
  def self.magnet_uri?(value : String) : Bool
    raise NotImplementedError.new "magnet_uri"
  end
end
