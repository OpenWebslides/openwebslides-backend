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

  # Constructor
  def initialize(attributes = [])
    attributes.each do |key, value|
      raise ActiveModel::UnknownAttributeError.new self, key unless respond_to? "#{key}="

      public_send "#{key}=", value
    end
  end

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
