# frozen_string_literal: true

##
# An alert requiring the user's attention
#
class Alert < ApplicationRecord
  ##
  # Properties
  #
  property :read
  property :count

  enum :alert_type => {
    :topic_updated => 0,
    :pr_submitted => 1,
    :pr_accepted => 2,
    :pr_rejected => 3
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

  # Validate presence and absence of fields when alert_type == :topic_updated
  validate :update_type_fields,
           :if => :topic_updated?

  # Validate presence and absence of fields when alert_type == :pr_*
  validate :pull_request_type_fields,
           :unless => :topic_updated?

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
end
