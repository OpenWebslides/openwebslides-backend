# frozen_string_literal: true

class ConfirmationPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def create?
    true
  end

  def update?
    true
  end
end
