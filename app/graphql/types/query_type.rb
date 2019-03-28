# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    ##
    # Root-level fields
    #
    field :users,
          [UserType],
          :null => false

    ##
    # Resolvers
    #
    def users
      context.pundit.send :policy_scope, User.all
    end
  end
end
