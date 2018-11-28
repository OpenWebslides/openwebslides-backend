# frozen_string_literal: true

##
# A login identity attached to a user account
#
class Identity < ApplicationRecord
  ##
  # Properties
  #

  # Unique user identifier
  attribute :uid

  # Identity provider
  attribute :provider

  ##
  # Associations
  #
  belongs_to :user

  ##
  # Validations
  #
  validates :uid,
            :presence => true,
            :uniqueness => { :scope => :provider }

  validates :provider,
            :presence => true

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
