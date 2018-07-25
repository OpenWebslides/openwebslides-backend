# frozen_string_literal: true

##
# User resource
#
class UserResource < ApplicationResource
  ##
  # Attributes
  #
  attribute :name
  attribute :email
  attribute :gravatar_hash
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
  filter :name
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
    super(context) - %i[gravatar_hash topics collaborations]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[gravatar_hash email tos_accepted]
  end

  def self.sortable_fields(context)
    super(context) - %i[gravatar_hash locale password tos_accepted]
  end

  def gravatar_hash
    Digest::MD5.hexdigest(email).downcase
  end
end
