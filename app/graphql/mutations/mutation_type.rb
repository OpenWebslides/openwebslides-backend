# frozen_string_literal: true

module Mutations
  class MutationType < Types::BaseObject
    ##
    # Root-level fields
    #
    field :mark_read,
          :mutation => Mutations::Alerts::MarkRead

    ##
    # Resolvers
    #
  end
end
