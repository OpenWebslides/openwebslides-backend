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

  # Define an attribute
  def self.attribute(attribute_sym, *_args)
    attr_accessor attribute_sym
  end

  # Define an association
  def self.belongs_to(attribute_sym, *args)
    attribute attribute_sym, *args

    validates attribute_sym,
              :presence => true
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
