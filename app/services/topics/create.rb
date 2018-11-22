# frozen_string_literal: true

module Topics
  ##
  # Persist a new topic in database and filesystem
  #
  class Create < ApplicationService
    def call(topic)
      # Return if topic has errors already
      # This happens because status is validated in TopicsController
      # FIXME: Move Topic#status from enum to state machine
      return topic if topic.errors.any?

      if topic.save
        # Persist to file system
        Repository::Create.new(topic).execute

        # Generate appropriate notifications
        Notifications::Create.call topic
      end

      topic
    end
  end
end
