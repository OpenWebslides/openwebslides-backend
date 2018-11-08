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
    # Users can only show user if the topic is showable
    # Authorize the user separately in the controller
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
