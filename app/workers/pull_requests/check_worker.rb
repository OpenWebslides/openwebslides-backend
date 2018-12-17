# frozen_string_literal: true

module PullRequests
  ##
  # Check if a pull request is mergeable
  #
  class CheckWorker < ApplicationWorker
    def perform(pull_request_id)
      pull_request = PullRequest.find pull_request_id

      compatible = Repo::Check.call pull_request.source, pull_request.target

      pull_request.update :state => (compatible ? 'open' : 'incompatible')
    end
  end
end
