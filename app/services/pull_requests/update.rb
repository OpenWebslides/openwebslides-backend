# frozen_string_literal: true

module PullRequests
  ##
  # Update a pull request
  #
  class Update < ApplicationService
    def call(pull_request, params)
      if pull_request.update params
        # Generate appropriate notifications
        if pull_request.previous_changes['state']&.last == 'accepted'
          Notifications::AcceptPR.call pull_request
        elsif pull_request.previous_changes['state']&.last == 'rejected'
          Notifications::RejectPR.call pull_request
        end
      end

      pull_request
    end
  end
end
