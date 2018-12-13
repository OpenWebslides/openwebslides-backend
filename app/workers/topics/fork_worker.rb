# frozen_string_literal: true

module Topics
  ##
  # Fork (duplicate) a topic in filesystem
  #
  class ForkWorker < ApplicationWorker
    def perform(topic_id, fork_id)
      topic = Topic.find topic_id
      fork = Topic.find fork_id

      # Fork repository in filesystem
      Repo::Fork.call topic, fork

      # Generate appropriate notifications
      Notifications::ForkTopic.call fork
    end
  end
end
