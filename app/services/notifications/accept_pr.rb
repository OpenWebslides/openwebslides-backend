# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a pull request is accepted
  #
  class AcceptPR < ApplicationService
    def call(pull_request)
      # Generate alert
      ([pull_request.target.user] + pull_request.target.collaborators).each do |user|
        alert = Alert.create :alert_type => :pr_accepted,
                             :user => user,
                             :pull_request => pull_request,
                             :topic => pull_request.target,
                             :subject => pull_request.user

        next unless user.alert_emails?

        AlertMailer.accept_pr(alert).deliver_later
      end
    end
  end
end
