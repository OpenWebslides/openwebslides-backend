# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a topic is created
  #
  class CreateTopic < ApplicationService
    def call(topic)
      # Generate feed item
      FeedItem.create :feed_item_type => :topic_created,
                      :user => topic.user,
                      :topic => topic
    end
  end
end
