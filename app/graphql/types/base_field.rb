# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    def initialize(*args, **kwargs, &block)
      # Authorized fields are only visible when the current_user is equal to the object
      @authorized = kwargs.delete :authorized

      super(*args, **kwargs, &block)
    end

    def to_graphql
      field = super # Returns a GraphQL::Field
      field.metadata[:authorized] = @authorized
      field
    end

    def authorized?(object, context)
      return true unless @authorized

      context.current_user == object
    end
  end
end
