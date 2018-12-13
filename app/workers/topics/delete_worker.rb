# frozen_string_literal: true

module Topics
  ##
  # Delete a new topic in database and filesystem
  #
  class DeleteWorker < ApplicationWorker
    def perform(topic_id)
      topic = Topic.find topic_id

      # Delete in filesystem
      Repo::Delete.call topic

      # Delete in database
      topic.destroy
    end
  end
end
