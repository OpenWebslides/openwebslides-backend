# frozen_string_literal: true

##
# Topic content
#
class ContentResource < ApplicationResource
  ##
  # Attributes
  #
  attribute :content_items

  ##
  # Relationships
  #
  has_one :topic

  ##
  # Filters
  #
  ##
  # Callbacks
  #
  ##
  # Overrides
  #
  def self.creatable_fields(context = {})
    super(context) - %i[content_items topic]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[content_items topic]
  end

  def self.sortable_fields(context = {})
    super(context) - %i[id content_items topic]
  end

  ##
  # Methods
  #
  def id
    topic.id
  end

  def content
    Repository::Read.call @model
  end
end
