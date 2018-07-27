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
  # Methods
  #
  def self.creatable_fields(_ = {})
    # Creation only needs email
    %i[email]
  end

  def self.updatable_fields(_ = {})
    %i[confirmation_token]
  end
end
