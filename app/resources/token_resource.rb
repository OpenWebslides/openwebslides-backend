# frozen_string_literal: true

##
# Token resource (returns an authentication token)
#
class TokenResource < ApplicationResource
  abstract

  ##
  # Attributes
  #
  attribute :email
  attribute :password

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
    super - %i[id email password]
  end

  def self.creatable_fields(context = {})
    super(context)
  end

  def self.updatable_fields(context = {})
    super(context) - %i[email password]
  end

  def self.sortable_fields(context = {})
    super(context) - %i[id email password]
  end

  ##
  # Methods
  #
end
