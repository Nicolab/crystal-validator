# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

# :ditto:
module Check
  # Declare a method as a checker.
  #
  # ```
  # # Triggered by the instance.
  # @[Check::Checker]
  # def custom_checker(v, format)
  #   puts "custom checker triggered on instance"
  # end
  #
  # # Triggered statically.
  # @[Check::Checker]
  # def self.custom_checker(v, h, cleaned_h, format)
  #   puts "custom checker triggered statically"
  #   cleaned_h
  # end
  # ```
  #
  # When `.check` and `#check` are called, the custom checkers are triggered respectively.
  annotation Checker; end

  # A mixin to make a class checkable.
  # This mixin includes `Checkable` and `CheckableStatic`.
  # It must be used in conjonction with `Check.rules`.
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
  #       check: {
  #         presence: {"Article content is required"},
  #         between:  {"The article content must be between 10 and 20 000 characters", 10, 20_000},
  #         # ...
  #       },
  #       clean: {
  #         type:    String,
  #         to:      :to_s,
  #         format:  ->(content : String) { content.strip },
  #         message: "Wrong type",
  #       },
  #     },
  #   )
  # end
  #
  # # Triggered on all data
  # v, article = Article.check(input_data)
  #
  # # Triggered on a value
  # v, content = Article.check_content(input_data["content"]?)
  # ```
  macro checkable
    include Check::Checkable
    extend Check::CheckableStatic
  end

  # Generates `check`, `check_{{field}}` and `clean_{{field}}` methods for *fields* (class variables).
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
  #       check: {
  #         presence: {"Article content is required"},
  #         between:  {"The article content must be between 10 and 20 000 characters", 10, 20_000},
  #         # ...
  #       },
  #       clean: {
  #         type:    String,
  #         to:      :to_s,
  #         format:  ->(content : String) { content.strip },
  #         message: "Wrong type",
  #       },
  #     },
  #       # ...
  # )
  # end
  #
  # # Triggered on all data
  # v, article = Article.check(input_data)
  #
  # # Triggered on all fields of an instance
  # article = Article.new(title: "foo", content: "bar")
  # v = article.check
  #
  # # Triggered on a value
  # v, content = Article.check_content(input_data["content"]?)
  #
  # # Cast and clean a value
  # ok, content = Article.clean_content(input_data["content"]?)
  # ```
  #
  # See also `Check.checkable`.
  macro rules(**fields)
    {% for field, rules in fields %}
      {% clean = rules["clean"] %}
      {% check = rules["check"] %}
      {% type = clean["type"] %}

      # Returns *{{field}}* with the good type and formatted if *format* is `true`.
      # The return type is a tuple with a bool as a first argument indicating
      # that the clean has been processed successfully or not and the 2nd
      # argument is the *value* cleaned.
      #
      # ```
      # ok, email = Checkable.clean_email(user_input["email"]) # => true, user@example.com
      # ```
      def self.clean_{{field}}(value, format = true) : Tuple(Bool, {{type}} | Nil)
        {% if to = clean["to"] %}
          # Check if the *value* has the method `{{to}}` and execute it if
          # exists to cast the value in the good type.
          if value.responds_to? {{to}}
            begin
              value = value.{{to.id}}
            rescue
              return false, nil
            end
          end
        {% end %}

        if value.is_a? {{type}} | Nil
          {% if format = clean["format"] %}
            # If *format* is true then call it to format *value*.
            if format
              begin
                return true, {{format}}.call(value)
              rescue
                return false, nil
              end
            else
              return true, value
            end
          {% else %}
            return true, value
          {% end %}
        end

        {false, nil}
      end

      # Create a new `Check::Validation` and checks *{{field}}*.
      # For more infos check `.check_{{field}}(v : Check::Validation, value, format : Bool = true)`
      def self.check_{{field}}(*, value, format : Bool = true) : Tuple(Check::Validation, {{type}} | Nil)
        v = Check.new_validation
        self.check_{{field}}(v, value, format)
      end

      # Cleans and check *value*.
      # If *format* is `true` it tells `.clean_{{field}}` to execute the `format` function
      # for this field if it has been defined with `Check.rules`.
      def self.check_{{field}}(v : Check::Validation, value, format : Bool = true) : Tuple(Check::Validation, {{type}} | Nil)
        # Cleans and formats the *value*
        ok, value = self.clean_{{field}}(value, format)

        # If clean has encountered an error, add error message and stop check here.
        if ok == false
          {% msg = clean["message"] || "Wrong type" %}
          v.add_error {{field.stringify}}, {{msg}}
          return v, value
        end

        # Check against each rule provided.
        # Each rule is executed if *value* is not `nil` except for `not_null`
        # which is executed even if the *value* is `nil`
        {% for name, args in check %}
          v.check(
            {{field.stringify}},
            {{args[0]}},
            {% if args.size <= 1 %}
              Valid.{{name.id}}? value
            {% else %}
              Valid.{{name.id}}? value, {{ args[1..-1].splat }}
            {% end %}
          ) {% if name != "not_null" %}unless value.nil?{% end %}
        {% end %}

        {v, value}
      end
    {% end %}
  end

  # Mixin that adds `.check` method to be used with a `Hash`.
  # The idea is to check a `Hash` against rules defined with `Check.rules`
  # plus executing custom checkers defined with `Checker` annotation.
  module CheckableStatic
    # Lifecycle method triggered before each call of `.check`.
    #
    # ```
    # # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
    # def self.before_check(v : Check::Validation, h, format : Bool)
    #   # Code...
    #   pp h
    # end
    # ```
    def before_check(v : Check::Validation, h : Hash, format = true); end

    # Lifecycle method triggered after each call of `.check`.
    #
    # This method (in static call) must returns the cleaned `Hash`
    # which is provided in the third argument.
    # You can update this cleaned hash but you have to return it.
    #
    # ```
    # # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
    # def self.after_check(v : Check::Validation, h, cleaned_h, format : Bool) : Hash
    #   # Code...
    #   pp cleaned_h
    #   cleaned_h # <= returns cleaned_h!
    # end
    # ```
    def after_check(v : Check::Validation, h : Hash, cleaned_h : Hash, format = true) : Hash
      cleaned_h
    end

    # Checks and clean the `Hash` for its fields corresponding
    # to class variables that have a `.check_{{field}}` method.
    #
    # It instantiates a `Check::Validation` and calls all methods
    # related to `.rules` and then methods defined with annotation `Checker`.
    #
    # Lifecycle methods `.before_check` and `.after_check` that are called
    # respectively at the beginning and at the end of the process.
    #
    # *format* is used to tell cleaners generated by `Check.rules`
    # to execute format method if it has been defined.
    def check(h : Hash, format = true)
      {% begin %}
      {% types = [] of Type %}
      {% fields = [] of String %}

      {% for ivar in @type.instance_vars.select { |ivar| @type.class.has_method?("check_#{ivar}") } %}
        {% types << ivar.type %}
        {% fields << ivar.name %}
      {% end %}

      # Instantiate a `Hash` with keys as `String` and values as a union of
      # all types of fields which have a method `.check_{field}`
      cleaned_h = Hash(String, {{types.join("|").id}}).new

      # Instantiate `Check::Validation`
      v = Check.new_validation

      # Call lifecycle method before check
      self.before_check v, h, format

      # Call check methods for fields that are present in *h*
      # and populate `cleaned_h`
      {% for field, i in fields %}
        if h.has_key? "{{field}}"
          v, value = self.check_{{field}}(v, h["{{field}}"], format)
          cleaned_h["{{field}}"] = value.as({{types[i]}})
        end
      {% end %}

      # Check methods with `Check::Checker` annotation
      {% for method in @type.class.methods.select { |method| method.annotation(Checker) } %}
        cleaned_h = {{method.name}} v, h, cleaned_h, format
      {% end %}

      # Call lifecycle method `.after_check`
      cleaned_h = self.after_check v, h, cleaned_h, format

      {v, cleaned_h}
      {% end %}
    end
  end

  # Mixin that adds `#check` method to be used with variables of an instance of the class including it.
  # The idea is to check the instance variables of the class extending it
  # against rules defined with `Check.rules` plus executing custom checkers defined with `Checker`.
  module Checkable
    # Lifecycle method triggered before each call of `#check`.
    #
    # ```
    # # Triggered on instance: `user.check`
    # def before_check(v : Check::Validation, format : Bool)
    #   # Code...
    # end
    # ```
    def before_check(v : Check::Validation, format : Bool = true); end

    # Lifecycle method triggered after each call of `#check`.
    #
    # ```
    # # Triggered on instance: `user.check`
    # def after_check(v : Check::Validation, format : Bool)
    #   # Code...
    # end
    # ```
    def after_check(v : Check::Validation, format : Bool = true); end

    # Checks the instance fields and clean them.
    #
    # It instantiates a `Check::Validation` and calls all methods
    # related to rules and then methods defined with annotation `Checker`.
    #
    # Lifecycle methods `#before_check` and `#after_check` that are triggered
    # respectively at the beginning and at the end of the process.
    #
    # *format* is used to tell cleaners generated by `Check.rules`
    # to execute format method if it has been defined.
    def check(format = true) : Validation
      {% begin %}
      # Instantiate `Check::Validation`
      v = Check.new_validation

      # Call lifecycle method before check
      before_check v, format

      # Check all fields that have a method `#check_{field}`
      {% for ivar in @type.instance_vars.select { |ivar| @type.class.has_method?("check_#{ivar}") } %}
        v, value = self.class.check_{{ivar.name}}(v, {{ivar.name}}, format)

        # If the field is not nilable and the value is nil,
        # it means that the clean method has failed
        # (to cast or an exception has been raised (and catched) in the formatter)
        # So ignore the nil value if the field is not nilable
        @{{ivar.name}} = value.as({{ivar.type}}) {% if !ivar.type.nilable? %} unless value.nil? {% end %}
      {% end %}

      # Check methods with `Check::Checker` annotation
      {% for method in @type.methods.select { |method| method.annotation(Checker) } %}
        {{method.name}} v, format
      {% end %}

      # Call lifecycle method `#after_check`
      after_check v, format

      v
      {% end %}
    end
  end
end
