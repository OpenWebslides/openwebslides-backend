# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    ##
    # Root-level fields
    #
    field :alerts,
          [AlertType],
          :null => false

    ##
    # Resolvers
    #
    def alerts
      context.pundit.send :policy_scope, Alert.all
    end
  end
end
