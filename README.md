# validator

∠(・.-)―〉 →◎ `validator` is a [Crystal](https://crystal-lang.org) micro validations module.<br>
Very simple and efficient, all validations return `true` or `false`.

Also [validator/check](#check) (not exposed by default) provides error message handling intended for the end user.

**Validator** respects the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle) and the [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy). It's a great basis tool for doing your own validation logic on top of it.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  validator:
    github: nicolab/crystal-validator
    # version: ~1 # Indicate the last version
```

2. Run `shards install`

## Usage

- [Validator - API docs](https://nicolab.github.io/crystal-validator/)

There are 2 main ways to use *validator*:

- As a simple validator to check rules (eg: email, url, min, max, presence, in, ...) which return a boolean.
- As a more advanced validation system which will check a series of rules and returns all validation errors encountered with custom or standard messages.

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

- [Validator - API docs](https://nicolab.github.io/crystal-validator/)

### Check

To perform a series of validations with error handling, the [validator/check](https://nicolab.github.io/crystal-validator/Check.html) module offers this possibility 👍

A [Validation](https://nicolab.github.io/crystal-validator/Check/Validation.html) instance provides the means to write sequential checks, fine-tune each micro-validation with their own rules and custom error message, the possibility to retrieve all error messages, etc.

```crystal
require "validator/check"

# Validates the *user* data received in the HTTP controller or other.
def validate_user(user : Hash) : Check::Validation
  v = Check.new_validation

  # -- email

  v.check :email, "The email is required.", is :presence?, :email, user
  v.check :email, "#{user[:email]} is an invalid email.", is :email?, user[:email]?

  # -- username

  v.check :username, "The username is required.", is :presence?, :username, user

  v.check(
    :username,
    "The username must contain at least 2 characters.",
    is :min?, user[:username]?, 2
  )

  v.check(
    :username,
    "The username must contain a maximum of 20 characters.",
    is :max?, user[:username]?, 20
  )
end

v = validate_user user

pp v.valid? # => true (or false)

errors = v.errors

# Inverse of v.valid?
if errors.empty?
  return "no error"
end

# Print all the errors (if any)
pp errors

# It's a Hash of Array
puts errors.size
puts errors.first_value
puts errors.each do |key, messages|
  puts key   # => :username
  puts messages # => ["The username is required.", "etc..."]
end
```

3 methods [#check](https://nicolab.github.io/crystal-validator/Check/Validation.html#instance-method-summary):

```crystal
# check(key : Symbol, valid : Bool)
# Using default error message
v.check(
  :username,
  is(:min?, user[:username]?, 2)
)

# check(key : Symbol, message : String, valid : Bool)
# Using custom error message
v.check(
  :username,
  "The username must contain at least 2 characters.",
  is(:min?, user[:username]?, 2)
)

# check(key : Symbol, valid : Bool, message : String)
# Using custom error message
v.check(
  :username,
  is(:min?, user[:username]?, 2),
  "The username must contain at least 2 characters."
)
```

`Check` is a simple and lightweight wrapper.
The `Check::Validation` is agnostic of the checked data,
of the context (model, controller, CSV file, HTTP data, socket data, JSON, etc).

> Use case example:
  Before saving to the database,
  the custom error messages can be used for the end user response.

Let your imagination run wild to add your logic around it.

### Custom validator

Just add your own method to register a custom *validator* or to overload an existing *validator*.

```crystal
module Validator
  # My custom validator
  def self.my_validator?(value, arg : String, another_arg : Int32) : Bool
    # TODO: write the logic of your validator
    return true
  end
end

# Call it
puts Valid.my_validator?("value to validate", "hello", 42) # => true

# or with the `is` flavor
puts is :my_validator?, "value to validate", "hello", 42 # => true
```

## Conventions

- The word "validator" is the method to make a "validation" (value validation).
- A *validator* returns `true` if the value (or/and the condition) is valid, `false` if not.
- The first argument(s) is (are) the value(s) to be validated.
- Always add the `Bool` return type to a *validator*.
- Always add the suffix `?` to the method name of a *validator*.
- If possible, indicates the type of the *validator* arguments.
- Spec: Battle tested.
- [KISS](https://en.wikipedia.org/wiki/KISS_principle) and [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).

## Development

```sh
crystal spec
crystal tool format --check
```

> TODO: add `ameba`

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
