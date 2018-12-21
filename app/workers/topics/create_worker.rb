# frozen_string_literal: true

module Topics
  ##
  # Create a new topic in filesystem
  #
  class CreateWorker < ApplicationWorker
    def perform(topic_id)
      topic = Topic.find topic_id

      # Persist to file system
      Repository::Create.call topic

      # Generate appropriate notifications
      Notifications::CreateTopic.call topic
    end
  end
end
