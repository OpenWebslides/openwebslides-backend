# frozen_string_literal: true

module Topics
  ##
  # Delete a topic in database and filesystem
  #
  class Delete < ApplicationService
    def call(topic)
      # Dispatch job to delete in database and filesystem
      Topics::DeleteWorker.perform_async topic.id
    end
  end
end
