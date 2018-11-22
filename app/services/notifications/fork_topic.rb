# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a topic is forked
  #
  class ForkTopic < ApplicationService
    def call(fork)
      # Generate feed item
      FeedItem.create :event_type => :topic_forked,
                      :user => fork.user,
                      :topic => fork

      # Generate alerts
      ([fork.upstream.user] + fork.upstream.collaborators).each do |user|
        alert = Alert.create :alert_type => :topic_forked,
                             :user => user,
                             :topic => fork.upstream,
                             :subject => fork.user

        next unless fork.upstream.user.alert_emails?

        AlertMailer.fork_topic(alert).deliver_later
      end
    end
  end
end
