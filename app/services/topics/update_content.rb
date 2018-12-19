# frozen_string_literal: true

module Topics
  ##
  # Update the contents of a topic in filesystem
  #
  class UpdateContent < ApplicationService
    def call(topic, content, user, message)
      # Write content to filesystem temporarily, so it does not gets serialized to Redis
      file = Dir::Tmpname.create('', nil) { |f| f }
      File.write file, content.to_yaml

      # Dispatch job to update in filesystem
      Topics::UpdateContentWorker.perform_async topic.id, file, user.id, message

      # TODO: handle asynchronous errors (OpenWebslides::Content::ContentError)
      # topic.errors.add :content, e.error_type

      # Return AR record
      topic
    end
  end
end
