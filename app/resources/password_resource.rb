# frozen_string_literal: true

##
# Password resource (resets the user's password)
#
class PasswordResource < ApplicationResource
  abstract

  ##
  # Attributes
  #
  attribute :reset_password_token
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
    super - %i[id email password reset_password_token]
  end

  def self.creatable_fields(context = {})
    super(context) - %i[password reset_password_token]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[email]
  end

  def self.sortable_fields(context = {})
    super(context) - %i[id email password reset_password_token]
  end

  ##
  # Methods
  #
end
