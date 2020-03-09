# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

module Validator
  @@rx_geo_lat = /^\(?[+-]?(90(\.0+)?|[1-8]?\d(\.\d+)?)$/
  @@rx_geo_lng = /^\s?[+-]?(180(\.0+)?|1[0-7]\d(\.\d+)?|\d{1,2}(\.\d+)?)\)?$/

  # Validates that the *value* is a valid format representation of
  # a geographical position (given in latitude and longitude).
  # - See also `#lat?`.
  # - See also `#lng?`.
  def self.lat_lng?(value : String) : Bool
    return false if !value.includes?(",")

    lat, lng = value.split(",")

    return false unless lat && lng
    return false if (lat.starts_with?('(') && !lng.ends_with?(')'))
    return false if (lng.ends_with?(')') && !lat.starts_with?('('))
    return true if lat.match(@@rx_geo_lat) && lng.match(@@rx_geo_lng)
    false
  end

  # Validates that the *value* is a valid format representation of a geographical latitude.
  # - See also `#lng?`.
  # - See also `#lat_lng?`.
  def self.lat?(value : String | Float) : Bool
    !value.to_s.match(@@rx_geo_lat).nil?
  end

  # Validates that the *value* is a valid format representation of a geographical longitude.
  # - See also `#lat?`.
  # - See also `#lat_lng?`.
  def self.lng?(value : String | Float) : Bool
    !value.to_s.match(@@rx_geo_lng).nil?
  end
end
