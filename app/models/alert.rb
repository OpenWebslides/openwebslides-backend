# frozen_string_literal: true

##
# An alert requiring the user's attention
#
class Alert < ApplicationRecord
  ##
  # Properties
  #
  property :read

  ##
  # Associations
  #
  belongs_to :user,
             :inverse_of => :alerts

  ##
  # Validations
  #
  ##
  # Callbacks
  #
  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
