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

      # Merge the pull request
      Repo::Merge.call pull_request.source, pull_request.target, user, message

      # Pull the commits (including merge commit) back into the fork
      Repo::Pull.call pull_request.target, pull_request.source

      pull_request.update :state => 'accepted'
    rescue OpenWebslides::Repo::ConflictsError => e
      pull_request.update :state => 'incompatible'
    end
  end
end
