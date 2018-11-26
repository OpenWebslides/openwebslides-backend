# frozen_string_literal: true

module Topics
  ##
  # Persist a new topic in database and filesystem
  #
  class Create < ApplicationService
    def call(topic)
      if topic.save
        # Persist to file system
        Repository::Create.call topic

        # Generate appropriate notifications
        Notifications::CreateTopic.call topic
      end

      topic
    end
  end
end
