# validator

[![CI Status](https://github.com/Nicolab/crystal-validator/workflows/CI/badge.svg?branch=master)](https://github.com/Nicolab/crystal-validator/actions) [![GitHub release](https://img.shields.io/github/release/Nicolab/crystal-validator.svg)](https://github.com/Nicolab/crystal-validator/releases) [![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://nicolab.github.io/crystal-validator/)

∠(・.-)―〉 →◎ `validator` is a [Crystal](https://crystal-lang.org) data validation module.<br>
Very simple and efficient, all validations return `true` or `false`.

Also [validator/check](#check) (not exposed by default) provides:

* Error message handling intended for the end user.
* Also (optional) a powerful and productive system of validation rules.
  With self-generated granular methods for cleaning and checking data.

**Validator** respects the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle) and the [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy). It's a great basis tool for doing your own validation logic on top of it.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  validator:
    github: nicolab/crystal-validator
```

2. Run `shards install`

## Usage

* [Validator - API docs](https://nicolab.github.io/crystal-validator/)

There are 3 main ways to use *validator*:

* As a simple validator to check rules (eg: email, url, min, max, presence, in, ...) which return a boolean.
* As a more advanced validation system which will check a series of rules and returns all validation errors encountered with custom or standard messages.
* As a system of validation rules (inspired by the _Laravel framework's Validator_)
  which makes data cleaning and data validation in Crystal very easy!
  With self-generated granular methods for cleaning and checking data of each field.

By default the **validator** module expose only `Validator` and `Valid` (alias) in the scope:

```crystal
require "validator"

Valid.email? "contact@example.org" # => true
Valid.url? "https://github.com/Nicolab/crystal-validator" # => true
Valid.my_validator? "value to validate", "hello", 42 # => true
```

An (optional) expressive validation flavor, `is` available as an alternative.
Not exposed by default, it must be imported:

```crystal
require "validator/is"

is :email?, "contact@example.org" # => true
is :url?, "https://github.com/Nicolab/crystal-validator" # => true
is :my_validator?, "value to validate", "hello", 42 # => true


# raises an error if the email is not valid
is! :email?, "contact@@example..org" # => Validator::Error
```

`is` is a macro, no overhead during the runtime 🚀
 By the nature of the macros, you can't pass the *validator* name dynamically with a variable like that `is(validator_name, "my value to validate", arg)`.
 But of course you can pass arguments with variables `is(:validator_name?, arg1, arg2)`.

* [Validator - API docs](https://nicolab.github.io/crystal-validator/)

### Validation rules

The validation rules can be defined directly when defining properties (with `getter` or `property`).
Or with the macro `Check.rules`. Depending on preference, it's the same under the hood.

```crystal
require "validator/check"

class User
  # Mixin
  Check.checkable

  # required
  property email : String, {
    required: true,

    # Optional lifecycle hook to be executed on `check_email` call.
    # Before the `check` rules, just after `clean_email` called inside `check_email`.
    # Proc or method name (here is a Proc)
    before_check: ->(v : Check::Validation, content : String?, required : Bool, format : Bool) {
      puts "before_check_content"
      content
    },

    # Optional lifecycle hook to be executed on `check_email` call, after the `check` rules.
    # Proc or method name (here is the method name)
    after_check: :after_check_email

    # Checker (all validators are supported)
    check: {
      not_empty: {"Email is required"},
      email:     {"It is not a valid email"},
    },

    # Cleaner
    clean: {
      # Data type
      type: String,

      # Converter (if union or other) to the expected value type.
      # Example if the input value is i32, but i64 is expected
      # Here is a String
      to: :to_s,

      # Formatter (any Crystal Proc) or method name (Symbol)
      format: :format_email,

      # Error message
      # Default is "Wrong type" but it can be customized
      message: "Oops! Wrong type.",
    }
  }

  # required
  property age : Int32, {
    required: "Age is required", # Custom message
    check: {
      min:     {"Age should be more than 18", 18},
      between: {"Age should be between 25 and 35", 25, 35},
    },
    clean: {type: Int32, to: :to_i32, message: "Unable to cast to Int32"},
  }

  # nilable
  property bio : String?, {
    check: {
      between: {"The user bio must be between 2 and 400 characters.", 2, 400},
    },
    clean: {
      type: String,
      to: :to_s,
      # `nilable` means omited if not provided,
      # regardless of Crystal type (nilable or not)
      nilable: true
    },
  }

  def initialize(@email, @age)
    init_props
  end

  # ---------------------------------------------------------------------------
  # Lifecycle methods (hooks)
  # ---------------------------------------------------------------------------

  # Triggered on instance: `user.check`
  private def before_check(v : Check::Validation, required : Bool, format : Bool)
    # Code...
  end

  # Triggered on instance: `user.check`
  private def after_check(v : Check::Validation, required : Bool, format : Bool)
    # Code...
  end

  # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
  private def self.before_check(v : Check::Validation, h, required : Bool, format : Bool)
    # Code...
    pp h
  end

  # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
  private def self.after_check(v : Check::Validation, h, cleaned_h, required : Bool, format : Bool)
    # Code...
    pp cleaned_h
    cleaned_h # <= returns cleaned_h!
  end

  # Triggered on a static call and on instance call: `User.check_email(value)`, `User.check(h)`, `user.check`.
  private def self.after_check_content(v : Check::Validation, content : String?, required : Bool, format : Bool)
    puts "after_check_content"
    puts "Valid? #{v.valid?}"
    content
  end

  # --------------------------------------------------------------------------
  #  Custom checkers
  # --------------------------------------------------------------------------

  # Triggered on instance: `user.check`
  @[Check::Checker]
  private def custom_checker(v : Check::Validation, required : Bool, format : Bool)
    # Code...
  end

    # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
  @[Check::Checker]
  private def self.custom_checker(v : Check::Validation, h, cleaned_h, required : Bool, format : Bool)
    # Code...
    cleaned_h # <= returns cleaned_h!
  end

  # --------------------------------------------------------------------------
  #  Formatters
  # --------------------------------------------------------------------------

  # Format (convert) email.
  def self.format_email(email)
    puts "mail stripped"
    email.strip
  end

  # --------------------------------------------------------------------------
  # Normal methods
  # --------------------------------------------------------------------------

  def foo()
    # Code...
  end

  def self.bar(v)
    # Code...
  end

  # ...
end
```

__Check__ with this example class (`User`):

```crystal
# Check a Hash (statically)
v, user_h = User.check(input_h)

pp v # => Validation instance
pp v.valid?
pp v.errors

pp user_h # => Casted and cleaned Hash

# Same but raise if there is a validation error
user_h = User.check!(input_h)

# Check a Hash (on instance)
user = user.new("demo@example.org", 38)

v = user.check # => Validation instance
pp v.valid?
pp v.errors

# Same but raise if there is a validation error
user.check! # => Validation instance

# Example with an active record model
user.check!.save

# Check field
v, email = User.check_email(value: "demo@example.org")
v, age = User.check_age(value: 42)

# Same but raise if there is a validation error
email = User.check_email!(value: "demo@example.org")

v, email = User.check_email(value: "demo@example.org ", format: true)
v, email = User.check_email(value: "demo@example.org ", format: false)

# Using an existing Validation instance
v = Check.new_validation
v, email = User.check_email(v, value: "demo@example.org")

# Same but raise if there is a validation error
email = User.check_email!(v, value: "demo@example.org")
```

__Clean__ with this example class (`User`):

```crystal
# `check` method cleans all values of the Hash (or JSON::Any),
# before executing the validation rules
v, user_h = User.check(input_h)

pp v # => Validation instance
pp v.valid?
pp v.errors

pp user_h # => Casted and cleaned Hash

# Cast and clean field
ok, email = User.clean_email(value: "demo@example.org")
ok, age = User.clean_age(value: 42)

ok, email = User.clean_email(value: "demo@example.org ", format: true)
ok, email = User.clean_email(value: "demo@example.org ", format: false)

puts "${email} is casted and cleaned" if ok
# or
puts "Email type error" unless ok
```

* `clean_*` methods are useful to caste a union value (like `Hash` or `JSON::Any`).
* Also `clean_*` methods are optional and handy for formatting values, such as the strip on the email in the example `User` class.

More details about cleaning, casting, formatting and return values:

By default `format` is `true`, to disable:

```crystal
ok, email = User.clean_email(value: "demo@example.org", format: false)
# or
ok, email = User.clean_email("demo@example.org", false)
```

Always use named argument if there is only one (the `value`):

```crystal
ok, email = User.clean_email(value: "demo@example.org")
```

`ok` is a boolean value that reports whether the cast succeeded. Like the type assertions in _Go_ (lang).
But the `ok` value is returned in first (like in _Elixir_ lang) for easy handling of multiple return values (`Tuple`).

Example with multiple values returned:

```crystal
ok, value1, value2 = User.clean_my_tuple({1, 2, 3})

# Same but raise if there is a validation error
value1, value2 = User.clean_my_tuple!({1, 2, 3})
```

Considering the example class above (`User`).
As a reminder, the email field has been defined with the formatter below:

```crystal
Check.rules(
  email: {
    clean: {
      type:    String,
      to:      :to_s,
      format:  ->self.format_email(String), # <= Here!
      message: "Wrong type",
    },
  },
)

# ...

# Format (convert) email.
def self.format_email(email)
  puts "mail stripped"
  email.strip
end
```

So `clean_email` cast to `String` and strip the value `" demo@example.org "`:

```crystal
# Email value with one space before and one space after
ok, email = User.clean_email(value: " demo@example.org ")

puts email # => "demo@example.org"

# Same but raise if there is a validation error
# Email value with one space before and one space after
email = User.clean_email!(value: " demo@example.org ")

puts email # => "demo@example.org"
```

If the email was taken from a union type (`json["email"]?`), the returned `email` variable would be a `String` too.

See [more examples](https://github.com/Nicolab/crystal-validator/tree/master/examples).

> NOTE: Require more explanations about `required`, `nilable` rules.
> Also about the converters JSON / Crystal Hash: `h_from_json`, `to_json_h`, `to_crystal_h`.
> In the meantime see the [API doc](https://nicolab.github.io/crystal-validator/Check/Checkable.html).

### Validation#check

To perform a series of validations with error handling, the [validator/check](https://nicolab.github.io/crystal-validator/Check.html) module offers this possibility 👍

A [Validation](https://nicolab.github.io/crystal-validator/Check/Validation.html) instance provides the means to write sequential checks, fine-tune each micro-validation with their own rules and custom error message, the possibility to retrieve all error messages, etc.

> `Validation` is also used with `Check.rules` and `Check.checkable`
  that provide a powerful and productive system of validation rules
  which makes data cleaning and data validation in Crystal very easy.
  With self-generated granular methods for cleaning and checking data.

To use the checker (`check`) includes in the `Validation` class:

```crystal
require "validator/check"

# Validates the *user* data received in the HTTP controller or other.
def validate_user(user : Hash) : Check::Validation
  v = Check.new_validation

  # -- email

  # Hash key can be a String or a Symbol
  v.check :email, "The email is required.", is :presence?, :email, user

  v.check "email", "The email is required.", is :presence?, "email", user
  v.check "email", "#{user["email"]} is an invalid email.", is :email?, user["email"]

  # -- username

  v.check "username", "The username is required.", is :presence?, "username", user

  v.check(
    "username",
    "The username must contain at least 2 characters.",
    is :min?, user["username"], 2
  )

  v.check(
    "username",
    "The username must contain a maximum of 20 characters.",
    is :max?, user["username"], 20
  )
end

v = validate_user user

pp v.valid? # => true (or false)

# Inverse of v.valid?
if v.errors.empty?
  return "no error"
end

# Print all the errors (if any)
pp v.errors

# It's a Hash of Array
errors = v.errors

puts errors.size
puts errors.first_value

errors.each do |key, messages|
  puts key   # => "username"
  puts messages # => ["The username is required.", "etc..."]
end
```

3 methods [#check](https://nicolab.github.io/crystal-validator/Check/Validation.html#instance-method-summary):

```crystal
# check(key : Symbol | String, valid : Bool)
# Using default error message
v.check(
  "username",
  is(:min?, user["username"], 2)
)

# check(key : Symbol | String, message : String, valid : Bool)
# Using custom error message
v.check(
  "username",
  "The username must contain at least 2 characters.",
  is(:min?, user["username"], 2)
)

# check(key : Symbol | String, valid : Bool, message : String)
# Using custom error message
v.check(
  "username",
  is(:min?, user["username"], 2),
  "The username must contain at least 2 characters."
)
```

`Check` is a simple and lightweight wrapper.
The `Check::Validation` is agnostic of the checked data,
of the context (model, controller, CSV file, HTTP data, socket data, JSON, etc).

> Use case example:
  Before saving to the database or process user data for a particular task,
  the custom error messages can be used for the end user response.

But a `Validation` instance can be used just to store validation errors:

```crystal
v = Check.new_validation
v.add_error("foo", "foo error!")
pp v.errors # => {"foo" => ["foo error!"]}
```

> See also `Check.rules` and `Check.checkable`.

Let your imagination run wild to add your logic around it.

### Custom validator

Just add your own method to register a custom *validator* or to overload an existing *validator*.

```crystal
module Validator
  # My custom validator
  def self.my_validator?(value, arg : String, another_arg : Int32) : Bool
    # write here the logic of your validator...
    return true
  end
end

# Call it
puts Valid.my_validator?("value to validate", "hello", 42) # => true

# or with the `is` flavor
puts is :my_validator?, "value to validate", "hello", 42 # => true
```

Using the custom validator with the validation rules:

```crystal
require "validator/check"

class Article
  # Mixin
  Check.checkable

  property title : String
  property content : String

  Check.rules(
    content: {
      # Now the custom validator is available
      check: {
        my_validator: {"My validator error message"},
        between: {"The article content must be between 10 and 20 000 characters", 10, 20_000},
        # ...
      },
    },
  )
end

# Triggered with all data
v, article = Article.check(input_data)

# Triggered with one value
v, content = Article.check_content(input_data["content"]?)
```

## Conventions

* The word "validator" is the method to make a "validation" (value validation).
* A *validator* returns `true` if the value (or/and the condition) is valid, `false` if not.
* The first argument(s) is (are) the value(s) to be validated.
* Always add the `Bool` return type to a *validator*.
* Always add the suffix `?` to the method name of a *validator*.
* If possible, indicates the type of the *validator* arguments.
* Spec: Battle tested.
* [KISS](https://en.wikipedia.org/wiki/KISS_principle) and [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).

## Development

```sh
crystal spec
crystal tool format
./bin/ameba
```

## Contributing

1. Fork it (<https://github.com/nicolab/crystal-validator/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## LICENSE

[MIT](https://github.com/Nicolab/crystal-validator/blob/master/LICENSE) (c) 2020, Nicolas Talle.

## Author

| [![Nicolas Tallefourtane - Nicolab.net](https://www.gravatar.com/avatar/d7dd0f4769f3aa48a3ecb308f0b457fc?s=64)](https://github.com/sponsors/Nicolab) |
|---|
| [Nicolas Talle](https://github.com/sponsors/Nicolab) |
| [![Make a donation via Paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=PGRH4ZXP36GUC) |

> Thanks to [ilourt](https://github.com/ilourt) for his great work on `checkable` mixins (clean_*, check_*, ...).
