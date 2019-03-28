# frozen_string_literal: true

module OpenWebslides
  class Schema < GraphQL::Schema
    # Root fields
    mutation Mutations::MutationType
    query Types::QueryType

    # Overrides
    context_class OpenWebslides::Context

    # Request limits
    max_depth 10
    max_complexity 300
    default_max_page_size 20

    # Raise error instead of returning nil on unauthorized objects
    def self.unauthorized_object(error)
      # Add a top-level error to the response instead of returning nil:
      raise GraphQL::ExecutionError, "An object of type #{error.type.graphql_name} was hidden due to permissions"
    end

    # Raise error instead of returning nil on unauthorized fields
    def self.unauthorized_field(error)
      # Add a top-level error to the response instead of returning nil:
      raise GraphQL::ExecutionError, "The field #{error.field.graphql_name} on an object of type #{error.type.graphql_name} was hidden due to permissions"
    end
  end
end
