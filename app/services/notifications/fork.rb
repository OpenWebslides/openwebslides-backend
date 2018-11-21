# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a topic is forked
  #
  class Fork < ApplicationService
    def call(fork)
      # Generate feed item
      FeedItem.create :event_type => :topic_forked,
                      :user => fork.user,
                      :topic => fork

      # Generate alert
      alert = Alert.create :alert_type => :topic_forked,
                           :user => fork.upstream.user,
                           :subject => fork.user

      AlertMailer.fork_topic(alert) if fork.upstream.user.alert_emails?
    end
  end
end
