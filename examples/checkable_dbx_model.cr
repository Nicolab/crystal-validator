module App::Models
  class User < DBX::ORM::Model
    adapter :pg

    @[JSON::Serializable::Options(emit_nulls: true)]
    class Schema
      include DB::Serializable
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      # Mixin
      Check.checkable

      property id : Int64?

      @[JSON::Field(key: "createdAt")]
      property created_at : Time

      @[JSON::Field(key: "updatedAt")]
      property updated_at : Time

      property username : String

      @[JSON::Field(key: "firstName")]
      property first_name : String

      property bio : String?

      Check.rules(
        # required
        username: {
          required: true,
          check:    {
            between: {"The username must be between 2 and 20 characters.", 2, 20},
          },
          clean: {type: String, to: :to_s},
        },

        # required
        first_name: {
          required: true,
          check:    {
            between: {"The first name must be between 2 and 20 characters.", 2, 20},
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
end

# ---------------------------------------------------------------------------- #

# Example: `create` HTTP endpoint (controller) handling the data validation.
def create(ctx : HTTP::Server::Context)
  return res_bad_req(ctx, "Invalid JSON") unless json = body_json(ctx.request)

  ok, user_h = User.h_from_json(json)
  return res_bad_req(ctx, "Invalid JSON") unless ok && user_h

  v, user_h = User.check user_h
  return res_validation_error(ctx, v) unless v.valid?

  user = User.create!(user_h)
  json_res(201, ctx, user)
end
