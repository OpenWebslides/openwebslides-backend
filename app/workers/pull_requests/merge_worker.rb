# frozen_string_literal: true

module PullRequests
  ##
  # Merge a pull request
  #
  class MergeWorker < ApplicationWorker
    def perform(pull_request_id, user_id)
      pull_request = PullRequest.find pull_request_id
      user = User.find user_id

      # TODO: i18n
      message = "Merge pull request ##{pull_request_id} from #{user.id}/#{pull_request.source.id}"

      Repo::Merge.call pull_request.source, pull_request.target, user, message

      pull_request.update :state => 'accepted'
    end
  end
end
