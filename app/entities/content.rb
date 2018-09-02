# frozen_string_literal: true

##
# Topic content structure - server->client DTO
#
# This entity is used when fetching the content structure of a topic
#
class Content < ApplicationEntity
  ##
  # Properties
  #
  attribute :content_items

  ##
  # Associations
  #
  belongs_to :topic

  # TODO: /contents/1/relationships/topic renders error
  # TODO: /topics/1/relationships/content renders error

  ##
  # Validations
  #
  validates :content_items,
            :presence => true

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.find(id)
    Topic.find(id).content
  end

  ##
  # Overrides
  #
  def content_items
    @content_items ||= TopicService.new(topic).read
  end

  ##
  # Helpers and callback methods
  #
end
