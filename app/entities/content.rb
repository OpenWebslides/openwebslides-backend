# frozen_string_literal: true

##
# Topic content structure
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
