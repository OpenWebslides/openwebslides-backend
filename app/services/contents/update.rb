# frozen_string_literal: true

module Contents
  ##
  # Update the contents of a topic
  #
  class Update < ApplicationService
    def call(topic, user, content, message)
      # Update in filesystem
      command = Repository::Update.new topic

      command.author = user
      command.content = content
      command.message = message

      command.execute

      # Generate appropriate notifications
      Notifications::Update.call topic, user

      topic
    rescue OpenWebslides::FormatError => e
      topic.errors.add :content, e.error_type
      topic
    end
  end
end
