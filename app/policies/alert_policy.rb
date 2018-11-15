# frozen_string_literal: true

class AlertPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def show?
    return false if @user.nil?

    # Owner can show alert
    @record.user == @user
  end

  ##
  # Relationship: user
  #
  def show_user?
    # Users can only show user if the alert is showable
    # Authorize the user separately in the controller
    show?
  end

  ##
  # Relationship: topic
  #
  def show_topic?
    # Users can only show topic if the alert is showable
    # Authorize the user separately in the controller
    show?
  end

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
  class Scope < Scope
    def resolve
      scope.where :user => @user
    end
  end
end
