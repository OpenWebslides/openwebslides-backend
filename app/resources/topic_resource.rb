# frozen_string_literal: true

##
# Slide topic resource
#
class TopicResource < ApplicationResource
  include Metadata::CreatedAt
  include Metadata::UpdatedAt

  ##
  # Attributes
  #
  attribute :title
  attribute :access
  attribute :description
  attribute :root_content_item_id
  attribute :has_open_pull_request

  ##
  # Relationships
  #
  has_one :user
  has_one :upstream
  has_one :content

  has_many :forks
  has_many :collaborators
  has_many :assets
  has_many :conversations
  has_many :incoming_pull_requests
  has_many :outgoing_pull_requests

  ##
  # Filters
  #
  filter :title
  filter :description
  filter :access,
         :verify => ->(values, _) { values & Topic.state_machine.states.map(&:name).map(&:to_s) }

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.creatable_fields(context = {})
    super(context) - %i[
      upstream content forks collaborators assets conversations
      has_open_pull_request incoming_pull_requests outgoing_pull_requests
    ]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[
      upstream root_content_item_id content forks collaborators assets conversations
      has_open_pull_request incoming_pull_requests outgoing_pull_requests
    ]
  end

  def self.sortable_fields(context)
    super(context) - %i[has_open_pull_request root_content_item_id]
  end

  def has_open_pull_request
    !_model.open_pull_request.nil?
  end
end
