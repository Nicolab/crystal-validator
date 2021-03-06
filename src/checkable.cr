# This file is part of "validator".
#
# This source code is licensed under the MIT license, please view the LICENSE
# file distributed with this source code. For the full
# information and documentation: https://github.com/Nicolab/crystal-validator
# ------------------------------------------------------------------------------

require "prop"

# :ditto:
module Check
  # Declare a method as a checker.
  #
  # ```
  # # Triggered by the instance.
  # @[Check::Checker]
  # def custom_checker(v : Check::Validation, required : Bool, format : Bool)
  #   puts "custom checker triggered on instance"
  # end
  #
  # # Triggered statically.
  # @[Check::Checker]
  # def self.custom_checker(v : Check::Validation, h, cleaned_h, required : Bool, format : Bool)
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
  #   property content : String, {
  #     required: true,
  #     check:    {
  #       not_empty: {"Article content is required"},
  #       between:   {"The article content must be between 10 and 20 000 characters", 10, 20_000},
  #       # ...
  #     },
  #     clean: {
  #       type:    String,
  #       to:      :to_s,
  #       format:  ->(content : String) { content.strip },
  #       message: "Wrong type",
  #     },
  #   }
  #
  #   def initialize(@title, @content)
  #   end
  # end
  #
  # # Triggered on all data
  # v, article = Article.check(input_data)
  #
  # # Triggered on a value
  # v, content = Article.check_content(input_data["content"]?)
  # ```
  macro checkable
    include Check::Prop
    include Check::Checkable
    extend Check::CheckableStatic
  end

  # A mixin to make the `getter` macro of the Crystal std's,
  # able to support the rules definition and factory block.
  module Prop
    macro included
      include Prop

      macro finished
        {% verbatim do %}
          {% for k, prop in PROPS %}
            {% if prop[:args] %}
              Check.rules({{prop[:name]}}: { {{prop[:args].double_splat}} })
            {% end %}
          {% end %}
        {% end %}
      end
    end
  end

  RULES = {} of String => HashLiteral(String, ASTNode)

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
  #   property url : String?
  #
  #   private def self.after_check_content(v : Check::Validation, content : String?, required : Bool, format : Bool)
  #     puts "after_check_content"
  #     puts "Valid? #{v.valid?}"
  #     content
  #   end
  #
  #   Check.rules(
  #     content: {
  #       required:     "Content is required", # or `true` to use the default error message
  #       before_check: ->(v : Check::Validation, content : String?, required : Bool, format : Bool) {
  #         puts "before_check_content"
  #         content
  #       },
  #       after_check: :after_check_email,
  #       check:       {
  #         not_empty: {"Article content is required"},
  #         between:   {"The article content must be between 10 and 20 000 characters", 10, 20_000},
  #         # ...
  #       },
  #       clean: {
  #         type: String,
  #         to:   :to_s,
  #         # Proc or method name (Symbol)
  #         format:  ->(content : String) { content.strip },
  #         message: "Wrong type",
  #       },
  #     },
  #     url: {
  #       check: {
  #         url: {"Article URL is invalid"},
  #       },
  #       clean: {
  #         # `nilable` means omited if not provided,
  #         # regardless of Crystal type (nilable or not)
  #         nilable: true,
  #         # Crystal type
  #         type: String,
  #         # Converter to the expected typed value
  #         to: :to_s,
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
      {% unless RULES["#{@type.name}"] %}
        {% RULES["#{@type.name}"] = {} of String => ASTNode %}
      {% end %}

      {% RULES["#{@type.name}"][field] = rules %}
    {% end %}

    # Returns all validation rules.
    private def self.validation_rules
      {
        {% for field, rules in RULES["#{@type.name}"] %}
          {{field}}: {{rules}},
        {% end %}
      }
    end

    # Returns `true` if a given *field* is required.
    private def self.validation_required?(field) : Bool
      fields = self.validation_rules
      return false if fields[field].nil?
      fields[field].fetch("required", false) == false ? false : true
    end

    # Returns `true` if a given *field* is nilable.
    private def self.validation_nilable?(field) : Bool
      fields = self.validation_rules
      return false if fields[field].nil? || fields[field]["clean"].nil?
      fields[field]["clean"].fetch("nilable", false).as(Bool)
    end

    {% for field, rules in fields %}
      {% clean = rules["clean"] %}
      {% check = rules["check"] %}
      {% type = clean["type"] %}
      {% nilable = clean["nilable"] %}

      # Same as `clean_{{field}}` but this method raises a `Validator::Error`
      # if the clean has not been processed successfully.
      #
      # ```
      # email = MyCheckable.clean_email!(user_input["email"]) # => user@example.com
      # ```
      def self.clean_{{field}}!(value, format = true) : {{type}}
        ok, value = self.clean_{{field}}(value, format)
        raise Validator::Error.new %(Cannot clean the "{{field}}" field) unless ok
        value.as({{type}})
      end

      # Returns *{{field}}* with the good type and formatted if *format* is `true`.
      # The return type is a tuple with a bool as a first argument indicating
      # that the clean has been processed successfully or not and the 2nd
      # argument is the *value* cleaned.
      #
      # ```
      # ok, email = MyCheckable.clean_email(user_input["email"]) # => true, user@example.com
      # ```
      def self.clean_{{field}}(value, format = true) : Tuple(Bool, {{type}} | Nil)
        # force real Nil type (hack for JSON::Any and equivalent)
        value = nil if value == nil

        {% if to = clean["to"] %}
          # Check if the *value* has the method `{{to}}` and execute it if
          # exists to cast the value in the good type (except if the value is nil and nilable).
          if value.responds_to? {{to}} {% if nilable %} && !value.nil?{% end %}
            begin
              value = value.{{to.id}}
            rescue
              return false, nil
            end
          end
        {% end %}

        # Format if the value as the correct (Crystal) type.
        # `| Nil` allows to format in the case of a nilable value (example `String?`)
        # where the `type` option of `clean` rules has been defined on the precise
        # Crystal type (example `String`).
        if value.is_a? {{type}} | Nil
          {% if format = clean["format"] %}
            # If *format* is true then call it to format *value*.
            if format
              begin
                return true,
                {% if format.is_a? SymbolLiteral %}
                  {{format.id}}(value)
                {% else %}
                  {{format}}.call(value)
                {% end %}
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

      # Checks *value* and returns it cleaned.
      # This method raises a `Check::ValidationError` if the validation fails.
      def self.check_{{field}}!(*, value, required : Bool = true, format : Bool = true) : {{type}}
        v, value = self.check_{{field}}(value: value, required: required, format: format)
        raise v.to_exception unless v.valid?
        value.as({{type}})
      end

      # Create a new `Check::Validation` and checks *{{field}}*.
      # For more infos check `.check_{{field}}(v : Check::Validation, value, format : Bool = true)`
      def self.check_{{field}}(
        *,
        value,
        required : Bool = true,
        format : Bool = true
      ) : Tuple(Check::Validation, {{type}} | Nil)
        v = Check.new_validation
        self.check_{{field}}(v, value, required, format)
      end

      # Checks *value* and returns it cleaned.
      # This method raises a `Check::ValidationError` if the validation fails.
      def self.check_{{field}}!(
        v : Check::Validation,
        value,
        required : Bool = true,
        format : Bool = true
      ) : {{type}}
        v, value = self.check_{{field}}(v, value, required, format)
        raise v.to_exception unless v.valid?
        value.as({{type}})
      end

      # Cleans and check *value*.
      # If *format* is `true` it tells `.clean_{{field}}` to execute the `format` function
      # for this field if it has been defined with `Check.rules`.
      def self.check_{{field}}(
        v : Check::Validation,
        value,
        required : Bool = true,
        format : Bool = true
      ) : Tuple(Check::Validation, {{type}} | Nil)
        # Cleans and formats the *value*
        ok, value = self.clean_{{field}}(value, format)

        # If clean has encountered an error, add error message and stop check here.
        if ok == false
          {% msg = clean["message"] || "Wrong type" %}
          v.add_error(
            {{field.stringify}},
            {{msg}}
          ) {% if nilable || (check["not_null"].nil? && check["not_empty"].nil?) %}unless value.nil?{% end %}

          return v, value
        end

        # Lifecycle: hook before_check_field
        {% if before_check = rules["before_check"] %}
          {% if before_check.is_a? SymbolLiteral %}
            value = {{before_check.id}}(v, value, required, format)
          {% else %}
            value = {{before_check}}.call(v, value, required, format)
          {% end %}
        {% end %}

        # Check against each rule provided.
        # Each rule is executed if *value* is not `nil` except for `not_null` and `not_empty`
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
          ) {% if nilable ||
                    (check["not_null"].nil? && check["not_empty"].nil?) ||
                    # required for the compiler
                    (name != "not_null" && name != "not_empty") %}unless value.nil?
            {% end %}
        {% end %}

        # Lifecycle: hook after_check_field
        {% if after_check = rules["after_check"] %}
          {% if after_check.is_a? SymbolLiteral %}
            value = {{after_check.id}}(v, value, required, format)
          {% else %}
            value = {{after_check}}.call(v, value, required, format)
          {% end %}
        {% end %}

        {v, value}
      end
    {% end %}
  end

  # Mixin that adds `.check` method to be used with a `Hash`.
  # The idea is to check a `Hash` against rules defined with `Check.rules`
  # plus executing custom checkers defined with `Checker` annotation.
  module CheckableStatic
    # Macro that returns the mapping of the JSON fields
    def map_json_keys : Hash(String, String)
      map = {} of String => String

      {% begin %}
        {% for ivar in @type.instance_vars %}
          {% ann = ivar.annotation(::JSON::Field) %}
          {% unless ann && ann[:ignore] %}
            map[{{ ((ann && ann[:key]) || ivar).id.stringify }}] = {{ivar.id.stringify}}
          {% end %}
        {% end %}
      {% end %}
      map
    end

    # Returns a new `Hash` with all JSON keys converted to Crystal keys.
    def to_crystal_h(h : Hash) : Hash
      cr_keys = map_json_keys

      # From JSON keys to Crystal keys
      h.transform_keys do |cr_k|
        cr_keys[cr_k]? || cr_k
      end
    end

    # Returns a new `Hash` with all Crystal keys converted to JSON keys.
    def to_json_h(h : Hash) : Hash
      cr_keys = map_json_keys

      # From Crystal keys to JSON keys
      h.transform_keys do |json_k|
        cr_keys.key_for? json_k || json_k
      end
    end

    # Returns a *json* `Hash` from a JSON input.
    # The return type is a tuple with a bool as a first argument indicating
    # that the `JSON.parse` has been processed successfully or not and the 2nd
    # argument is the *json* Hash.
    #
    # ```
    # ok, user_h = User.h_from_json(json) # => true, {"username" => "Bob", "email" => "user@example.com"}
    # ```
    def h_from_json(json : String | IO)
      return true, self.to_crystal_h(JSON.parse(json).as_h)
    rescue
      return false, nil
    end

    # Returns a *json* `Hash` from a JSON input.
    # Same as `h_from_json`, except that this method raises a `JSON::ParseException` if the conversion fails.
    #
    # ```
    # user_h = User.h_from_json!(json) # => {"username" => "Bob", "email" => "user@example.com"}
    # ```
    def h_from_json!(json : String | IO)
      self.to_crystal_h(JSON.parse(json).as_h)
    end

    # Lifecycle method triggered before each call of `.check`.
    #
    # ```
    # # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
    # def self.before_check(v : Check::Validation, h, required : Bool = true, format : Bool = true)
    #   # Code...
    #   pp h
    # end
    # ```
    def before_check(
      v : Check::Validation,
      h : Hash,
      required : Bool = true,
      format : Bool = true
    ); end

    # Lifecycle method triggered after each call of `.check`.
    #
    # This method (in static call) must returns the cleaned `Hash`
    # which is provided in the third argument.
    # You can update this cleaned hash but you have to return it.
    #
    # ```
    # # Triggered on a static call: `User.check(h)` (with a `Hash` or `JSON::Any`)
    # def self.after_check(v : Check::Validation, h, cleaned_h, required : Bool = true, format : Bool = true) : Hash
    #   # Code...
    #   pp cleaned_h
    #   cleaned_h # <= returns cleaned_h!
    # end
    # ```
    def after_check(
      v : Check::Validation,
      h : Hash, cleaned_h : Hash,
      required : Bool = true,
      format : Bool = true
    ) : Hash
      cleaned_h
    end

    # Same as `check` but this method raises a `Check::ValidationError`
    # if the validation fails or if the clean has not been processed successfully.
    #
    # ```
    # cleaned_h = MyCheckable.check!(v, h)
    # ```
    def check!(v : Check::Validation, h : Hash, required : Bool = true, format : Bool = true)
      v, cleaned_h = check(v, h, required, format)
      raise v.to_exception unless v.valid?
      cleaned_h
    end

    # Checks and clean the `Hash` for its fields corresponding
    # to class variables that have a `.check_{{field}}` method.
    #
    # It instantiates a `Check::Validation` (if not provided) and calls all methods
    # related to `.rules` and then methods defined with annotation `Checker`.
    #
    # Lifecycle methods `.before_check` and `.after_check` that are called
    # respectively at the beginning and at the end of the process.
    #
    # *format* is used to tell cleaners generated by `Check.rules`
    # to execute format method if it has been defined.
    def check(v : Check::Validation, h : Hash, required : Bool = true, format : Bool = true)
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

      # Call lifecycle method before check
      self.before_check v, h, required, format

      # Call check methods for fields that are present in *h*
      # and populate `cleaned_h`
      {% for field, i in fields %}
      {% field_name = field.stringify %}
        # if hash has the field
        if h.has_key?({{field_name}})
          v, value = self.check_{{field}}(v, h[{{field_name}}]?, required, format)
          cleaned_h[{{field_name}}] = value.as({{types[i]}})

        # or if this field MUST be checked when required
        elsif required && self.validation_required?({{field_name}})
          required_msg = self.validation_rules[{{field_name}}].fetch(:required, nil)

          msg = if required_msg && required_msg.is_a?(String)
            required_msg.as(String)
          else
            "This field is required"
          end

          v.add_error {{field_name}}, msg
        end
      {% end %}

      # Check methods with `Check::Checker` annotation
      {% for method in @type.class.methods.select(&.annotation(Checker)) %}
        cleaned_h = {{method.name}} v, h, cleaned_h, required, format
      {% end %}

      # Call lifecycle method `.after_check`
      cleaned_h = self.after_check v, h, cleaned_h, required, format

      {v, cleaned_h}
      {% end %}
    end

    # Same as `check` but this method raises a `Check::ValidationError`
    # if the validation fails or if the clean has not been processed successfully.
    #
    # ```
    # cleaned_h = MyCheckable.check!(h)
    # ```
    def check!(h : Hash, required : Bool = true, format : Bool = true)
      v, cleaned_h = check(h, required, format)
      raise v.to_exception unless v.valid?
      cleaned_h
    end

    # :ditto:
    def check(h : Hash, required : Bool = true, format : Bool = true)
      v = Check.new_validation
      check v, h, required, format
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
    # def before_check(v : Check::Validation, required : Bool = true, format : Bool = true)
    #   # Code...
    # end
    # ```
    def before_check(
      v : Check::Validation,
      required : Bool = true,
      format : Bool = true
    ); end

    # Lifecycle method triggered after each call of `#check`.
    #
    # ```
    # # Triggered on instance: `user.check`
    # def after_check(v : Check::Validation, required : Bool = true, format : Bool = true)
    #   # Code...
    # end
    # ```
    def after_check(
      v : Check::Validation,
      required : Bool = true,
      format : Bool = true
    ); end

    # Same as `check` but this method raises a `Check::ValidationError`
    # if the validation fails or if the clean has not been processed successfully.
    #
    # ```
    # v = Validation.new_validation
    # myCheckable.check!(v) # => Returns the current instance.
    # ```
    #
    # This method returns `self`, so it chainable :)
    #
    # ```
    # v = Validation.new_validation
    # user.email = "me@example.org"
    # user.check!(v).save
    # ```
    def check!(v : Check::Validation, required : Bool = true, format : Bool = true) : self
      v = check(v, required, format)
      raise v.to_exception unless v.valid?
      self
    end

    # Checks the instance fields and clean them.
    #
    # It instantiates a `Check::Validation` (if not provided) and calls all methods
    # related to rules and then methods defined with annotation `Checker`.
    #
    # Lifecycle methods `#before_check` and `#after_check` that are triggered
    # respectively at the beginning and at the end of the process.
    #
    # *format* is used to tell cleaners generated by `Check.rules`
    # to execute format method if it has been defined.
    def check(v : Check::Validation, required : Bool = true, format : Bool = true) : Validation
      {% begin %}

      # Call lifecycle method before check
      before_check v, required, format

      # Check all fields that have a method `#check_{field}`
      {% for ivar in @type.instance_vars.select { |ivar| @type.class.has_method?("check_#{ivar}") } %}
        v, value = self.class.check_{{ivar.name}}(v, {{ivar.name}}, required, format)

        # If the field is not nilable and the value is nil,
        # it means that the clean method has failed
        # (to cast or an exception has been raised (and catched) in the formatter)
        # So ignore the nil value if the field is not nilable
        @{{ivar.name}} = value.as({{ivar.type}}) {% if !ivar.type.nilable? %} unless value.nil? {% end %}
      {% end %}

      # Check methods with `Check::Checker` annotation
      {% for method in @type.methods.select(&.annotation(Checker)) %}
        {{method.name}} v, required, format
      {% end %}

      # Call lifecycle method `#after_check`
      after_check v, required, format

      v
      {% end %}
    end

    # Same as `check` but this method raises a `Check::ValidationError`
    # if the validation fails or if the clean has not been processed successfully.
    #
    # ```
    # myCheckable.check! # => Returns the current instance.
    # ```
    #
    # This method returns `self`, so it chainable :)
    #
    # ```
    # user.email = "me@example.org"
    # user.check!.save
    # ```
    def check!(required : Bool = true, format : Bool = true) : self
      v = check(required, format)
      raise v.to_exception unless v.valid?
      self
    end

    # :ditto:
    def check(required : Bool = true, format : Bool = true) : Validation
      v = Check.new_validation
      check v, required, format
    end
  end
end
