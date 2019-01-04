# frozen_string_literal: true

module Topics
  ##
  # Update the contents of a topic in filesystem
  #
  class UpdateContentWorker < ApplicationWorker
    def perform(topic_id, file, user_id, message)
      topic = Topic.find topic_id
      user = User.find user_id

      # Read content from temporary file
      content = YAML.load_file file

      # Update in filesystem
      Repo::Update.call topic, content, user, message

      # Trigger a PR recheck on open and incompatible incoming/outgoing pull requests
      PullRequest.where(:source => topic)
                 .or(PullRequest.where(:target => topic))
                 .select { |pr| pr.open? || pr.incompatible? }.each do |pull_request|
        PullRequests::CheckWorker.perform_async pull_request.id
      end

      # Generate appropriate notifications
      Notifications::UpdateTopic.call topic, user

      # Delete temporary file
      FileUtils.remove file
    end
  end
end
