# frozen_string_literal: true

module Topics
  ##
  # Update the contents of a topic in filesystem
  #
  class UpdateContentWorker < ApplicationWorker
    def perform(topic_id, content, user_id, message)
      topic = Topic.find topic_id
      user = User.find user_id

      # Update in filesystem
      Repository::Update.call topic, content, user, message

      # Generate appropriate notifications
      Notifications::UpdateTopic.call topic, user
    end
  end
end
