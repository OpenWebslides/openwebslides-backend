# frozen_string_literal: true

module PullRequests
  ##
  # Update a pull request
  #
  class Update < ApplicationService
    def call(pull_request, params)
      if pull_request.update params
        if pull_request.working?
          # Merge pull request
          PullRequests::MergeWorker.perform_async pull_request.id

          # Generate appropriate notifications
          Notifications::AcceptPR.call pull_request
        elsif pull_request.rejected?
          # Generate appropriate notifications
          Notifications::RejectPR.call pull_request
        end
      end

      pull_request
    end
  end
end
