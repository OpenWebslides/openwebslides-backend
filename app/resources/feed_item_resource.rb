# frozen_string_literal: true

##
# Recent Activity feed resource
#
class FeedItemResource < ApplicationResource
  include CreatedAt

  immutable

  ##
  # Attributes
  #
  attribute :feed_item_type
  attribute :user_name
  attribute :topic_title

  ##
  # Relationships
  #
  has_one :user,
          :always_include_linkage_data => true

  has_one :topic,
          :always_include_linkage_data => true

  ##
  # Filters
  #
  filter :user
  filter :topic
  filter :feed_item_type,
         :verify => ->(values, _ = nil) { values.map(&:downcase) & FeedItem.feed_item_types.keys }

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.sortable_fields(_)
    %i[created_at]
  end

  def self.default_sort
    [{ :field => 'created_at', :direction => :desc }]
  end

  def user_name
    @model.user.name
  end

  def topic_title
    @model.topic.title
  end
end
