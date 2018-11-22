# frozen_string_literal:true

module Annotations
  ##
  # Persist a new conversation in the database
  #
  class CreateConversation < ApplicationService
    def call(conversation)
      if conversation.save
        # Generate appropriate notifications
        Notifications::CreateConversation.call conversation
      end

      conversation
    end
  end
end
