# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "json"
require "./validators/*"

# ∠(・.-)―〉 →◎ `validator` is a [Crystal](https://crystal-lang.org) data validation module.
# Very simple and efficient, all validations return `true` or `false`.
#
# Also [validator/check](https://nicolab.github.io/crystal-validator/Check.html)
# (not exposed by default) provides error message handling intended for the end user.
#
# There are 2 main ways to use *validator*:
#
# - As a simple validator to check rules (eg: email, url, min, max, presence, in, ...) which return a boolean.
# - As a more advanced validation system which will check a series of rules
#  and returns all validation errors encountered with custom or standard messages.
#
# By default the **validator** module expose only `Validator` and `Valid` (alias) in the scope:
#
# ```
# require "validator"
#
# Valid.email? "contact@example.org"                        # => true
# Valid.url? "https://github.com/Nicolab/crystal-validator" # => true
# Valid.my_validator? "value to validate", "hello", 42      # => true
# ```
#
# An (optional) expressive validation flavor, `is` available as an alternative.  \
# Not exposed by default, it must be imported:
#
# ```
# require "validator/is"
#
# is :email?, "contact@example.org"                        # => true
# is :url?, "https://github.com/Nicolab/crystal-validator" # => true
# is :my_validator?, "value to validate", "hello", 42      # => true
#
# # raises an error if the email is not valid
# is! :email?, "contact@@example..org" # => Validator::Error
# ```
#
# `is` is a macro, no overhead during the runtime 🚀
#  By the nature of the macros, you can't pass the *validator* name dynamically
#  with a variable like that `is(validator_name, "my value to validate", arg)`.
#  But of course you can pass arguments with variables `is(:validator_name?, arg1, arg2)`.
#
#
# ## Check
#
# Make a series of checks, with a customized error message for each case.
#
# ```crystal
# require "validator/check"
#
# check = Check.new
#
# check("email", "The email is required.", is :absence?, "email", user)
# ```
# ## Custom validator
#
# Just add your own method to register a custom *validator* or to overload an existing *validator*.
#
# ```crystal
# module Validator
#   # My custom validator
#   def self.my_validator?(value, arg : String, another_arg : Int32) : Bool
#     # write here the logic of your validator...
#     return true
#   end
# end
#
# # Call it
# puts Valid.my_validator?("value to validate", "hello", 42) # => true
#
# # or with the `is` flavor
# puts is :my_validator?, "value to validate", "hello", 42 # => true
# ```
#
# `Check` is a simple and lightweight wrapper, let your imagination run wild to add your logic around it.
#
# Using the custom validator with the validation rules:
#
# ```
# require "validator/check"
#
# class Article
#   # Mixin
#   Check.checkable
#
#   property title : String
#   property content : String
#
#   Check.rules(
#     content: {
#       # Now the custom validator is available
#       check: {
#         my_validator: {"My validator error message"},
#         between:      {"The article content must be between 10 and 20 000 characters", 10, 20_000},
#         # ...
#       },
#     },
#   )
# end
#
# # Triggered with all data
# v, article = Article.check(input_data)
#
# # Triggered with one value
# v, content = Article.check_content(input_data["content"]?)
# ```
module Validator
  VERSION = "1.0.0"

  # Used by `is!` when a validation is not `true`.
  class Error < Exception; end
end

# Alias of `Validator`
alias Valid = Validator
