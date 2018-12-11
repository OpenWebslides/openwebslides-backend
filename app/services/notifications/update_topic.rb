# frozen_string_literal:true

module Notifications
  ##
  # Generate feed item and alert when a topic is updated
  #
  class UpdateTopic < ApplicationService
    def call(topic, user)
      # Generate feed item
      FeedItem.create :feed_item_type => :topic_updated,
                      :user => user,
                      :topic => topic
    end
  end
end
