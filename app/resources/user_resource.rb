# frozen_string_literal: true

##
# User resource
#
class UserResource < ApplicationResource
  ##
  # Attributes
  #
  attribute :first_name
  attribute :last_name
  attribute :email
  attribute :locale
  attribute :password
  attribute :tos_accepted

  ##
  # Relationships
  #
  ##
  # Relationships
  #
  has_many :topics
  has_many :collaborations

  ##
  # Filters
  #
  filter :first_name
  filter :last_name
  filter :email

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def fetchable_fields
    if context[:current_user] == _model
      super - %i[password tos_accepted]
    else
      super - %i[email locale password tos_accepted]
    end
  end

  def self.creatable_fields(context = {})
    super(context) - %i[decks collaborations conversions]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[email tos_accepted]
  end

  def self.sortable_fields(context)
    super(context) - %i[locale password tos_accepted]
  end
end
