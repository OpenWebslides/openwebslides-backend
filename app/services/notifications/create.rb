# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a topic is created
  #
  class Create < ApplicationService
    def call(topic)
      # Generate feed item
      FeedItem.create :event_type => :topic_created,
                      :user => topic.user,
                      :topic => topic
    end
  end
end
