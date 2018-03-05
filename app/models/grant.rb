# frozen_string_literal: true

##
# Access grant to a topic (collaborators)
#
class Grant < ApplicationRecord
  ##
  # Properties
  #
  ##
  # Associations
  #
  belongs_to :topic,
             :required => true

  belongs_to :user,
             :required => true

  ##
  # Validations
  #
  validates_uniqueness_of :topic_id, :scope => :user_id

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
