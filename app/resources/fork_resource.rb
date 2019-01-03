# frozen_string_literal: true

##
# Fork topic (abstract)
#
class ForkResource < ApplicationResource
  abstract

  ##
  # Attributes
  #
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
    super - %i[id]
  end

  def self.creatable_fields(context = {})
    super(context) - %i[]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[id]
  end

  def self.sortable_fields(context = {})
    super(context) - %i[id]
  end

  ##
  # Methods
  #
end
