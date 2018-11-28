# frozen_string_literal: true

module Topics
  ##
  # Update the contents of a topic
  #
  class UpdateContent < ApplicationService
    def call(topic, content, user, message)
      # Update in filesystem
      Repository::Update.call topic, content, user, message

      # Generate appropriate notifications
      Notifications::UpdateTopic.call topic, user

      topic
    rescue OpenWebslides::FormatError => e
      topic.errors.add :content, e.error_type
      topic
    end
  end
end
