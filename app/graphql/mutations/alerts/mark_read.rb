# frozen_string_literal: true

module Mutations
  module Alerts
    class MarkRead < Mutations::BaseMutation
      ##
      # Arguments
      #
      argument :id,
               ID,
               :required => true

      ##
      # Return type
      #
      field :alert,
            Types::AlertType,
            :null => false

      ##
      # Resolvers
      #
      def resolve(**input)
        alert = Alert.find input[:id]

        alert.update :read => true

        { :alert => alert }
      end

      ##
      # Authorization
      #
      def self.authorized?(hash, context)
        context.pundit.send :authorize, hash[:alert], :update?
      end
    end
  end
end
