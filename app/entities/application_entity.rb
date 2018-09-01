# frozen_string_literal: true

##
# A virtual entity
#
class ApplicationEntity
  include ActiveModel::Validations

  ##
  # Properties
  #
  ##
  # Associations
  #
  ##
  # Validations
  #
  ##
  # Callbacks
  #
  ##
  # Methods
  #

  # Define a property
  def self.property(property_sym, *_args)
    attr_accessor property_sym
  end

  # Define an association
  def self.belongs_to(property_sym, *args)
    property property_sym, *args

    validates property_sym,
              :presence => true
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
