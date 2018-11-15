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

  validates :topic,
            :presence => true,
            :if => :topic_updated?

  validates :subject,
            :presence => true,
            :unless => :topic_updated?

  validates :pull_request,
            :presence => true,
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
end
