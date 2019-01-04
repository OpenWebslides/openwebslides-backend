# frozen_string_literal: true

##
# A request to merge a topic into another topic
#
class PullRequest < ApplicationRecord
  ##
  # Properties
  #

  # Message from the user who submitted the pull request
  attribute :message

  # Message from the user who accepted/rejected the pull request
  attribute :feedback

  ##
  # Associations
  #
  belongs_to :user

  # Topic that will be merged from
  belongs_to :source,
             :class_name => 'Topic',
             :inverse_of => :outgoing_pull_requests

  # Topic that will be merge into
  belongs_to :target,
             :class_name => 'Topic',
             :inverse_of => :incoming_pull_requests

  ##
  # State
  #
  state_machine :initial => :pending do
    state :pending, :incompatible, :ready do
      validates :feedback,
                :absence => true
    end

    state :working, :accepted

    state :rejected do
      validates :feedback,
                :presence => true
    end

    # Accept/approve a pull request
    event :accept do
      transition :ready => :working
    end

    # Reject a pull request
    event :reject do
      transition :ready => :rejected
    end
  end

  ##
  # Validations
  #
  validates :message,
            :presence => true

  validate :target_is_upstream_source

  validate :source_has_one_open_pr,
           :on => :create

  validate :feedback_updated_only_on_state_change,
           :on => :update

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def open?
    pending? || ready?
  end

  def closed?
    working? || incompatible? || accepted? || rejected?
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def target_is_upstream_source
    return if source&.upstream == target

    errors.add :source, I18n.t('openwebslides.validations.pull_request.target_is_upstream_source')
  end

  def source_has_one_open_pr
    return unless source&.outgoing_pull_requests&.any?(&:open?)

    errors.add :source, I18n.t('openwebslides.validations.pull_request.source_has_one_open_pr')
  end

  def feedback_updated_only_on_state_change
    return unless feedback_changed? && !state_changed?

    errors.add :feedback, I18n.t('openwebslides.validations.pull_request.feedback_updated_only_on_state_change')
  end
end
