# frozen_string_literal: true

##
# A request to merge a topic into another topic
#
class PullRequest < ApplicationRecord
  ##
  # Properties
  #

  # Message from the user who submitted the pull request
  property :message

  # Message from the user who accepted/rejected the pull request
  property :feedback

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
  state_machine :initial => :open do
    state :open, :value => 0
    state :accepted, :value => 1
    state :rejected, :value => 2

    # Accept/approve a pull request
    event :accept do
      transition :open => :accepted
    end

    # Reject a pull request
    event :reject do
      transition :open => :rejected
    end
  end

  ##
  # Validations
  #
  validates :message,
            :presence => true

  validate :target_is_upstream_source

  validate :source_has_one_open_pr

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def closed?
    accepted? || rejected?
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def target_is_upstream_source
    return if source.upstream == target

    errors.add :source, I18n.t('openwebslides.validations.pull_request.target_is_upstream_source')
  end

  def source_has_one_open_pr
    return unless source.outgoing_pull_requests.any?(&:open?)

    errors.add :source, I18n.t('openwebslides.validations.pull_request.source_has_one_open_pr')
  end
end
