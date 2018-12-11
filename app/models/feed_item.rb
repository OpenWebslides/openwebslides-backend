# frozen_string_literal: true

##
# An item in the Recent Activity feed
#
class FeedItem < ApplicationRecord
  ##
  # Properties
  #
  enum :feed_item_type => %i[topic_created topic_updated topic_forked]

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
