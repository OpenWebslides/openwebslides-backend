# frozen_string_literal: true

class OpenWebslidesSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
