# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a conversation is created
  #
  class CreateConversation < ApplicationService
    def call(conversation)
      # TODO: generate feed item

      # TODO: generate alert
      ConversationMailer.create(conversation).deliver_later
    end
  end
end
