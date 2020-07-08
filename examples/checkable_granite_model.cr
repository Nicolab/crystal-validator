module App::Models
  @[JSON::Serializable::Options(emit_nulls: true)]
  class User < Granite::Base
    # Mixin
    Check.checkable

    connection app

    table "users"

    column id : Int64, primary: true

    @[JSON::Field(key: "createdAt")]
    column created_at : Time

    @[JSON::Field(key: "updatedAt")]
    column updated_at : Time

    column username : String

    @[JSON::Field(key: "firstName")]
    column first_name : String

    column bio : String?

    Check.rules(
      # required
      username: {
        required: true,
        check: {
          between:   {"The username must be between 2 and 20 characters.", 2, 20},
        },
        clean: {type: String, to: :to_s},
      },

      # required
      first_name: {
        required: true,
        check: {
          between:   {"The first name must be between 2 and 20 characters.", 2, 20},
        },
        clean: {type: String, to: :to_s},
      },

      # nilable
      bio: {
        check: {
          between: {"The user bio must be between 2 and 400 characters.", 2, 400},
        },
        clean: {type: String, to: :to_s, nilable: true},
      },
    )
  end
end

# ---------------------------------------------------------------------------- #

# Example: `create` HTTP endpoint (controller) handling the data validation.
def create(ctx : HTTP::Server::Context)
  return res_bad_req(ctx, "Invalid JSON") unless json = body_json(ctx.request)

  ok, user_h = User.h_from_json(json)
  return res_bad_req(ctx, "Invalid JSON") unless ok && user_h

  v, user_h = User.check user_h
  return res_validation_error(ctx, v) unless v.valid?

  user = User.create(user_h)
  return json_res_close(500, ctx, user.errors) unless user.id

  json_res(201, ctx, user)
end
