# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

# An (optional) expressive flavor of `Validator` (or `Valid` alias).
# Not exposed by default, must be imported:
#
# ```
# require "validator/is"
#
# is :email?, "contact@example.org"                        # => true
# is "email?", "contact@example.org"                       # => true
# is :url?, "https://github.com/Nicolab/crystal-validator" # => true
# ```
macro is(name, *args)
  # Symbol ? String
  Valid.{{ name.id.chars[0] == ':' ? name[1..-1].id : name.id }} {{args.splat}}
end

# Same as `is` but `raise` a `Validator::Error`
# displaying an inspection if the validation is `false`.
# Useful for the unit tests :)
macro is!(name, *args)
  # Symbol ? String
  valid = Valid.{{ name.id.chars[0] == ':' ? name[1..-1].id : name.id }} {{args.splat}}

  if valid == false
    raise Validator::Error.new "Is not \"#{{{name}}}\":\n#{{{args.stringify}}}"
  end

  true
end
