# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a pull request is rejected
  #
  class RejectPR < ApplicationService
    def call(pull_request)
      # Generate alert
      ([pull_request.source.user] + pull_request.source.collaborators).each do |user|
        alert = Alert.create :alert_type => :pr_rejected,
                             :user => user,
                             :pull_request => pull_request,
                             :topic => pull_request.target,
                             :subject => pull_request.target.user

        next unless user.alert_emails?

        AlertMailer.reject_pr(alert).deliver_later
      end
    end
  end
end
