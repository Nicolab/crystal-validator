# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

# Standalone check module that provides a practical workflow for validations.
module Check
  # Validation errors.
  # It's a `Hash` used as a container of errors, in order to handle them easily.
  #
  # ```
  # v = Check.new_validation
  # pp v.errors
  # ```
  alias Errors = Hash(Symbol, Array(String))

  # Combines a series of checks into one validation instance,
  # with a customized error message for each case.
  #
  # A `Validation` instance provides the means to write sequential checks,
  # fine-tune each micro-validation with their own rules and custom error message,
  # the possibility to retrieve all error messages, etc.
  #
  # ```crystal
  # require "validator/check"
  #
  # # Validates the *user* data received in the HTTP controller or other.
  # def validate_user(user : Hash) : Check::Validation
  #   v = Check.new_validation
  #
  #   # -- email
  #
  #   v.check :email, "The email is required.", is :presence?, :email, user
  #   v.check :email, "#{user[:email]} is an invalid email.", is :email?, user[:email]?
  #
  #   # -- username
  #
  #   v.check :username, "The username is required.", is :presence?, :username, user
  #
  #   v.check(
  #     :username,
  #     "The username must contain at least 2 characters.",
  #     is :min?, user[:username]?, 2
  #   )
  #
  #   v.check(
  #     :username,
  #     "The username must contain a maximum of 20 characters.",
  #     is :max?, user[:username]?, 20
  #   )
  # end
  #
  # v = validate_user user
  #
  # pp v.valid? # => true (or false)
  #
  # errors = v.errors
  #
  # # Inverse of v.valid?
  # if errors.empty?
  #   return "no error"
  # end
  #
  # # display all the errors (if any)
  # pp errors
  #
  # # It's a Hash of Array
  # puts errors.size
  # puts errors.first_value
  # puts errors.each do |key, messages|
  #   puts key      # => :username
  #   puts messages # => ["The username is required.", "etc..."]
  # end
  # ```
  #
  # 3 methods [#check](https://nicolab.github.io/crystal-validator/docs/Check/Validation.html#instance-method-summary):
  #
  # ```crystal
  # # check(key : Symbol, valid : Bool)
  # # Using default standard error message
  # v.check(
  #   :username,
  #   is(:min?, user[:username]?, 2)
  # )
  #
  # # check(key : Symbol, message : String, valid : Bool)
  # # Using custom error message
  # v.check(
  #   :username,
  #   "The username must contain at least 2 characters.",
  #   is(:min?, user[:username]?, 2)
  # )
  #
  # # check(key : Symbol, valid : Bool, message : String)
  # # Using custom error message
  # v.check(
  #   :username,
  #   is(:min?, user[:username]?, 2),
  #   "The username must contain at least 2 characters."
  # )
  # ```
  #
  # `Check` is a simple and lightweight wrapper.
  # The `Check::Validation` is agnostic of the checked data,
  # of the context (model, controller, CSV file, HTTP data, socket data, JSON, etc).
  #
  # > Use case example:
  #   Before saving to the database,
  #   the custom error messages can be used for the end user response.
  #
  # Let your imagination run wild to add your logic around it.
  #
  class Validation
    @errors : Errors

    # Initializes a validation.
    #
    # ```
    # v = Check::Validation.new
    # ```
    #
    # Same as:
    #
    # ```
    # v = Check.new_validation
    # ```
    def initialize
      @errors = Errors.new
    end

    # Initializes a validation using an existing *errors* `Hash` (`Check::Errors`).
    #
    # ```
    # v = Check::Validation.new
    # ```
    #
    # Same as:
    #
    # ```
    # v = Check.new_validation
    # ```
    def initialize(errors : Errors)
      @errors = errors
    end

    # Errors container.
    #
    # ```
    # v = Check.new_validation
    # pp v.errors
    # ```
    def errors : Errors
      @errors
    end

    # Add a validation error.
    #
    # ```
    # v = Check.new_validation
    # v.add_error(:foo, "Foo error!")
    # pp v.errors # => {:foo => ["Foo error!"]}
    # ```
    #
    # See also: `Errors`
    def add_error(key : Symbol, message : String) : Validation
      message = "\"#{key}\" is not valid." if message.blank?

      @errors[key] = Array(String).new unless @errors.has_key? key
      @errors[key] << message

      self
    end

    # Add a validation error.
    #
    # > By default a standard message is used.
    #
    # ```
    # v = Check.new_validation
    # v.add_error(:foo)
    # pp v.errors # => {:foo => ["\"foo\" is not valid."]}
    # ```
    #
    # See also: `Errors`
    def add_error(key : Symbol) : Validation
      add_error key, ""
      self
    end

    # Returns `true` if there is no error, `false` if there is one or more errors.
    def valid?
      @errors.empty?
    end

    # Checks a validation, often used in sequence.
    #
    # If *valid* is `false`, the error *message* is added in the `errors`.
    # Nothing if *valid* is `true`.
    #
    # ```
    # v = Check.new_validation
    #
    # # -- email
    #
    # v.check :email, "The email is required.", is :presence?, :email, user
    # v.check :email, "#{user[:email]} is an invalid email.", is :email?, user[:email]?
    #
    # # -- username
    #
    # v.check :username, "The username is required.", is :presence?, :username, user
    #
    # v.check(
    #   :username,
    #   "The username must contain at least 2 characters.",
    #   is :min?, user[:username]?, 2
    # )
    #
    # v.check(
    #   :username,
    #   "The username must contain a maximum of 20 characters.",
    #   is :max?, user[:username]?, 20
    # )
    #
    # # Print all errors
    # pp v.errors
    # ```
    def check(key : Symbol, message : String, valid : Bool) : Validation
      add_error(key, message) unless valid
      self
    end

    # Checks a validation, often used in sequence.
    #
    # If *valid* is `false`, the error *message* is added in the `errors`.
    # Nothing if *valid* is `true`.
    #
    # ```
    # v = Check.new_validation
    #
    # # -- email
    #
    # v.check(:email, is(:presence?, :email, user), "The email is required.")
    # v.check(:email, is(:email?, user[:email]?), "#{user[:email]} is an invalid email.")
    #
    # # -- username
    #
    # v.check(:username, is(:presence?, :username, user), "The username is required.")
    #
    # v.check(
    #   :username,
    #   is :min?, user[:username]?, 2,
    #     "The username must contain at least 2 characters."
    # )
    #
    # v.check(
    #   :username,
    #   is :max?, user[:username]?, 20,
    #     "The username must contain a maximum of 20 characters."
    # )
    #
    # # Print all errors
    # pp v.errors
    # ```
    def check(key : Symbol, valid : Bool, message : String) : Validation
      add_error(key, message) unless valid
      self
    end

    # Checks a validation, often used in sequence.
    #
    # If *valid* is `false`, an error message is added in the `errors`.
    # Nothing if *valid* is `true`.
    #
    # > Unlike other `check` methods, with this one a default standard message is used.
    #
    # ```
    # v = Check.new_validation
    #
    # v.check(:email, is(:presence?, :email, user))
    # v.check(:email, is(:email?, user[:email]?))
    #
    # # Print all errors
    # pp v.errors
    # ```
    def check(key : Symbol, valid : Bool) : Validation
      add_error(key, "") unless valid
      self
    end
  end

  # Initializes a new `Validation` instance to combine
  # a series of checks (`Validation#check`).
  #
  # ```
  # v = Check.new_validation
  # ```
  #
  # Same as:
  #
  # ```
  # v = Check::Validation.new
  # ```
  def self.new_validation
    Validation.new
  end

  # Initializes a new `Validation` instance to combine
  # a series of checks (`Validation#check`).
  # using an existing *errors* `Hash` (`Check::Errors`).
  #
  # ```
  # v = Check.new_validation existing_errors
  # ```
  #
  # Same as:
  #
  # ```
  # v = Check::Validation.new existing_errors
  # ```
  def self.new_validation(errors : Errors)
    Validation.new errors
  end
end
