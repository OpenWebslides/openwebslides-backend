# frozen_string_literal: true

##
# Topic content structure
#
class Content < ApplicationEntity
  ##
  # Properties
  #
  attribute :content_items

  ##
  # Associations
  #
  belongs_to :topic

  ##
  # Validations
  #
  validates :content_items,
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
  def content
    TopicService.new(topic).read
  end

  ##
  # Helpers and callback methods
  #
end
