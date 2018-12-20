# frozen_string_literal: true

##
# Base annotation resource
#
class AnnotationResource < ApplicationResource
  include Metadata::CreatedAt

  ##
  # Attributes
  #
  attribute :content_item_id
  attribute :rating
  attribute :rated

  # State
  attribute :secret
  attribute :edited
  attribute :flagged
  attribute :deleted

  ##
  # Relationships
  #
  has_one :user
  has_one :topic

  ##
  # Filters
  #
  filter :user
  filter :content_item_id
  filter :rated

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def self.creatable_fields(context = {})
    super(context) - %i[rating rated secret edited flagged deleted]
  end

  def self.updatable_fields(context = {})
    super(context) - %i[content_item_id user topic rating rated edited flagged deleted]
  end

  def rating
    _model.ratings.count
  end

  def rated
    _model.ratings.where(:user => context[:current_user]).any?
  end

  ##
  # State methods
  #
  def secret
    _model.secret?
  end

  def edited
    _model.edited?
  end

  def flagged
    _model.flagged?
  end

  def deleted
    _model.hidden?
  end
end
