# frozen_string_literal: true

##
# Alert resource
#
class AlertResource < ApplicationResource
  immutable

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
  def self.sortable_fields(_)
    %i[created_at]
  end

  def self.default_sort
    [{ :field => 'created_at', :direction => :desc }]
  end

  def meta(options)
    {
      options[:serializer].key_formatter.format(:created_at) => DateValueFormatter.format(_model.created_at)
    }
  end
end
