# frozen_string_literal: true

##
# Topic content structure - client->server DTO
#
# This entity is used when updating the content structure of a topic
#
class Commit < ApplicationEntity
  ##
  # Properties
  #
  attribute :content_items
  attribute :message

  ##
  # Associations
  #
  belongs_to :topic
  belongs_to :user

  # TODO: /commits/1/relationships/topic renders error
  # TODO: /commits/1/relationships/user renders error

  ##
  # Validations
  #
  validates :content_items,
            :presence => true

  validates :message,
            :presence => true

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def save
    raise NotImplementedError
  end

  def save!
    raise NotImplementedError
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
end
