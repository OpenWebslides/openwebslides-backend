# frozen_string_literal: true

##
# Topic content
#
class ContentResource < ApplicationResource
  abstract

  ##
  # Attributes
  #
  attribute :content

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
  # Methods
  #
  def content
    TopicService.new(@model).read
  end
end
