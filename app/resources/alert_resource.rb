# frozen_string_literal: true

##
# Alert resource
#
class AlertResource < ApplicationResource
  include CreatedAt

  ##
  # Attributes
  #
  attribute :read
  attribute :alert_type
  attribute :count

  ##
  # Relationships
  #
  has_one :user
  has_one :topic
  has_one :pull_request
  has_one :subject,
          :class_name => 'User'

  ##
  # Filters
  #
  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.updatable_fields(context = {})
    super(context) - %i[alert_type count pull_request user topic subject]
  end

  def self.sortable_fields(_)
    %i[created_at]
  end

  def self.default_sort
    [{ :field => 'created_at', :direction => :desc }]
  end
end
