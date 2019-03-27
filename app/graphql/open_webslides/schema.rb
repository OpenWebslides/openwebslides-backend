# frozen_string_literal: true

module OpenWebslides
  class Schema < GraphQL::Schema
    # Root fields
    mutation Types::MutationType
    query Types::QueryType

    # Overrides
    context_class Context

    # Request limits
    max_depth 10
    max_complexity 300
    default_max_page_size 20
  end
end
