# frozen_string_literal: true

module Topics
  ##
  # Update the contents of a topic in filesystem
  #
  class UpdateContent < ApplicationService
    def call(topic, content, user, message)
      # Dispatch job to update in filesystem
      Topics::UpdateContentWorker.perform_async topic.id, content, user.id, message

      # TODO: handle asynchronous errors (OpenWebslides::Content::ContentError)
      # topic.errors.add :content, e.error_type

      # Return AR record
      topic
    end
  end
end
