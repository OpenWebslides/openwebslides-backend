# frozen_string_literal: true

##
# An alert requiring the user's attention
#
class PullRequestAlert < Alert
  ##
  # Properties
  #
  ##
  # Associations
  #
  belongs_to :pull_request

  belongs_to :subject,
             :class_name => 'User'

  validate :alert_type_is_pr

  ##
  # Validations
  #
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
  def alert_type_is_pr
    errors.add :alert_type unless %w[pr_submitted pr_approved pr_rejected].include? alert_type
  end
end
