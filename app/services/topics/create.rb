# frozen_string_literal: true

module Topics
  ##
  # Persist a new topic in database and filesystem
  #
  class Create < ApplicationService
    def call(topic)
      if topic.save
        # Dispatch job to persist in filesystem
        Topics::CreateWorker.perform_async topic.id
      end

      topic
    end
  end
end
