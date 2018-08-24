# frozen_string_literal: true

##
# Confirmation resource (confirms the user's account)
#
class ConfirmationResource < ApplicationResource
  abstract

  ##
  # Attributes
  #
  attribute :confirmation_token
  attribute :email

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
    super - %i[id confirmation_token email]
  end

  def self.creatable_fields(context = {})
    super(context) - %i[confirmation_token]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[email]
  end

  def self.sortable_fields(context = {})
    super(context) - %i[id email confirmation_token]
  end

  ##
  # Methods
  #
end
