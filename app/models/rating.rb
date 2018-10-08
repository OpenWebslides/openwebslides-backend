# frozen_string_literal: true

##
# A user's rating (approval) on an annotation
#
class Rating < ApplicationRecord
  ##
  # Properties
  #
  ##
  # Associations
  #
  belongs_to :annotation,
             :inverse_of => :ratings

  belongs_to :user,
             :inverse_of => :ratings

  ##
  # Validations
  #
  validates_uniqueness_of :user, :scope => :annotation

  validate :annotation_unlocked

  ##
  # Callbacks
  #
  before_destroy :ensure_annotation_unlocked

  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def ensure_annotation_unlocked
    annotation_unlocked

    throw :abort if annotation.locked?
  end

  ##
  # Validate whether the annotation is not hidden or flagged
  #
  def annotation_unlocked
    errors.add :base, 'annotation (or parent) cannot be hidden or flagged' if annotation.locked?
  end
end
