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
      User.all
    end
  end
end
