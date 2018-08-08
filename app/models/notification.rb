# frozen_string_literal: true

##
# A notification for the social feed
#
class Notification < ApplicationRecord
  ##
  # Properties
  #
  enum :event_type => %i[topic_created topic_updated]

  ##
  # Associations
  #
  belongs_to :user,
             :inverse_of => :notifications

  belongs_to :topic,
             :inverse_of => :notifications

  ##
  # Validations
  #
  validates :event_type,
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
