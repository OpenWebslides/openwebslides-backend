# frozen_string_literal: true

class PullRequestAlertPolicy < AlertPolicy
  ##
  # Resource
  #
  ##
  # Relationship: subject
  #
  def show_subject?
    # Users can only show subject if the alert is showable
    # Authorize the subject separately in the controller
    show?
  end

  ##
  # Relationship: pull_request
  #
  def show_pull_request?
    # Users can only show pull_request if the alert is showable
    # Authorize the pull_request separately in the controller
    show?
  end

  ##
  # Scope
  #
  class Scope < Scope; end
end
