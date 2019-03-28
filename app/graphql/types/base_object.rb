# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField

    def self.authorized?(record, context)
      # Ignore when called from Types::QueryType because record is nil
      return true unless record

      context.pundit.send :authorize, record, :show?
    end
  end
end
