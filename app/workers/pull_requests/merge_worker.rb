# frozen_string_literal: true

module PullRequests
  ##
  # Merge a pull request
  #
  class MergeWorker < ApplicationWorker
    def perform(pull_request_id)
      pull_request = PullRequest.find pull_request_id

      Repo::Merge.call pull_request.source, pull_request.target

      pull_request.update :state => 'accepted'
    end
  end
end
