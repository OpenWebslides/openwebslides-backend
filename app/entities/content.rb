# frozen_string_literal: true

##
# Topic content structure
#
class Content < ApplicationEntity
  ##
  # Properties
  #
  attribute :content

  ##
  # Associations
  #
  belongs_to :topic

  ##
  # Validations
  #
  validates :content,
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
