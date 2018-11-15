# frozen_string_literal: true

##
# Topic content
#
class ContentResource < ApplicationResource
  abstract

  ##
  # Attributes
  #
  attribute :content
  attribute :message

  ##
  # Relationships
  #
  ##
  # Filters
  #
  ##
  # Callbacks
  #
  ##
  # Overrides
  #
  def self.fields
    super - %i[id message]
  end

  def self.creatable_fields(context = {})
    super(context) - %i[content message]
  end

  def self.updatable_fields(context = {})
    super(context)
  end

  def self.sortable_fields(context = {})
    super(context) - %i[id content message]
  end

  ##
  # Methods
  #
  def content
    TopicService.new(@model).read
  end
end
