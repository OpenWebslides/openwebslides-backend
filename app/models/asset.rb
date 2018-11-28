# frozen_string_literal: true

##
# A binary asset
#
class Asset < ApplicationRecord
  ##
  # Properties
  #

  # Relative path to asset file
  attribute :filename

  ##
  # Associations
  #
  belongs_to :topic,
             :inverse_of => :assets

  ##
  # Validations
  #
  validates :filename,
            :presence => true,
            :uniqueness => { :scope => :topic }

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
