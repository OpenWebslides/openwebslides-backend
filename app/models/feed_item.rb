# frozen_string_literal: true

##
# An item in the Recent Activity feed
#
class FeedItem < ApplicationRecord
  ##
  # Properties
  #
  enum :feed_item_type => {
    :topic_created => 0,
    :topic_updated => 1,
    :topic_forked => 2
  }

  ##
  # Associations
  #
  belongs_to :user,
             :inverse_of => :feed_items

  belongs_to :topic,
             :inverse_of => :feed_items

  ##
  # Validations
  #
  validates :feed_item_type,
            :presence => true

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
