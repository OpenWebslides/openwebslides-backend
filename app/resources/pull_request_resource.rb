# frozen_string_literal: true

##
# Pull request resource
#
class PullRequestResource < ApplicationResource
  immutable

  ##
  # Attributes
  #
  attribute :message
  attribute :feedback
  attribute :state

  ##
  # Relationships
  #
  has_one :user
  has_one :source
  has_one :target

  ##
  # Filters
  #
  filter :state,
         :verify => ->(values, _) { values & PullRequest.state_machine.states.map { |s| s.name.to_s } }

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.creatable_fields(context = {})
    super(context) - %i[feedback state]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[message user source target]
  end

  def self.sortable_fields(context)
    super(context) - %i[message feedback]
  end

  def meta(options)
    {
      options[:serializer].key_formatter.format(:created_at) => DateValueFormatter.format(_model.created_at)
    }
  end

  # Override state to show the state name instead of the identifier
  def state
    _model.state_name.to_s
  end
end
