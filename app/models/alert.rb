# frozen_string_literal: true

##
# An alert requiring the user's attention
#
class Alert < ApplicationRecord
  ##
  # Properties
  #
  attribute :read
  attribute :count

  enum :alert_type => {
    :topic_updated => 0,
    :pr_submitted => 1,
    :pr_accepted => 2,
    :pr_rejected => 3,
    :topic_forked => 4
  }

  ##
  # Associations
  #
  belongs_to :user,
             :inverse_of => :alerts

  belongs_to :topic,
             :optional => true

  belongs_to :pull_request,
             :optional => true

  belongs_to :subject,
             :class_name => 'User',
             :optional => true

  ##
  # Validations
  #
  validates :count,
            :presence => true,
            :numericality => { :only_integer => true },
            :if => :topic_updated?

  validate :update_read_is_true,
           :on => :update

  # Validate presence and absence of fields when alert_type == :topic_updated
  validate :update_type_fields,
           :if => :topic_updated?

  # Validate presence and absence of fields when alert_type == :pr_*
  validate :pull_request_type_fields,
           :if => :pull_request_type?

  # Validate topic equals pull request target
  validate :topic_equals_target,
           :if => :pull_request_type?

  # Validate presence and absence of fields when alert_type == :topic_forked
  validate :forked_type_fields,
           :if => :forked_type?

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  def update_type?
    topic_updated?
  end

  def pull_request_type?
    pr_submitted? || pr_accepted? || pr_rejected?
  end

  def forked_type?
    topic_forked?
  end

  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def update_type_fields
    # Topic must be present
    errors.add :topic, :blank unless topic

    # Subject and pull request must be blank
    errors.add :subject, :present if subject
    errors.add :pull_request, :present if pull_request
  end

  def pull_request_type_fields
    # Topic, subject and pull request must be present
    errors.add :topic, :blank unless topic
    errors.add :subject, :blank unless subject
    errors.add :pull_request, :blank unless pull_request

    # Count must be blank
    errors.add :count, :present if count?
  end

  def forked_type_fields
    # Topic and subject must be present
    errors.add :topic, :blank unless topic
    errors.add :subject, :blank unless subject

    # Count and pull request must be blank
    errors.add :count, :present if count?
    errors.add :pull_request, :present if pull_request
  end

  def topic_equals_target
    return if topic == pull_request&.target

    errors.add :topic, I18n.t('openwebslides.validations.alert.topic_equals_target')
  end

  def update_read_is_true
    errors.add :read, I18n.t('openwebslides.validations.alert.update_read_is_true') unless read
  end
end
