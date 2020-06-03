module Check

  annotation Rules
  end

  annotation Checker
  end

  module Checkable
    def before_check(v : Check::Validation)
    end

    def after_check(v : Check::Validation)
    end

    def check
      v = Check.new_validation

      before_check v

      {% begin %}
        # Check rules
        {%for ivar in @type.instance_vars.select { |ivar| ivar.annotation(Rules)} %}
          {% rules = ivar.annotation(Rules).named_args %}
          value = {{ivar.id}}
          {% if rules["not_empty"] %}
            {% args = rules["not_empty"] %}
            v.check(
              {{ivar.stringify}},
              {{args[0]}},
              {% if rule.size <= 1 %}
                is :{{rule.id}}?, value
              {% else %}
                is :{{rule.id}}?, value, {{ args[1..-1].splat }}
              {% end %}
            )
          {% end %}

          {% for rule, args in rules %}
            v.check(
              {{ivar.stringify}},
              {{args[0]}},
              {% if rule.size <= 1 %}
                is :{{rule.id}}?, value
              {% else %}
                is :{{rule.id}}?, value, {{ args[1..-1].splat }}
              {% end %}
            ) unless value.nil?
          {% end %}
        {% end %}

        # Check methods with Check::Checker annotation
        {% for method in @type.methods.select { |method| method.annotation(Checker)} %}
          {{method.name}} v
        {% end %}

        {% debug %}
      {% end %}

      after_check v

      v
    end
  end
end
