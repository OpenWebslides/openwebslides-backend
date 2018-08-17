# frozen_string_literal: true

##
# Slide topic resource
#
class TopicResource < ApplicationResource
  ##
  # Attributes
  #
  attribute :title
  attribute :state
  attribute :description
  attribute :root_content_item_id

  ##
  # Relationships
  #
  has_one :user
  has_one :content
  has_many :collaborators
  has_many :assets
  has_many :conversations

  ##
  # Filters
  #
  filter :title
  filter :description
  filter :state,
         :verify => ->(values, _) { values & Topic.states.keys }

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.creatable_fields(context = {})
    super(context) - %i[content collaborators assets conversations]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[root_content_item_id content collaborators assets conversations]
  end

  def self.sortable_fields(context)
    super(context) - %i[root_content_item_id]
  end
end
