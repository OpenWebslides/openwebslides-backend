# frozen_string_literal: true

class TokenPolicy < ApplicationPolicy
  ##
  # Resource
  #
  def create?
    # Everyone can create a token
    true
  end

  def update?
    # Users can update a token
    !@user.nil?
  end

  def destroy?
    # Users can update a token
    update?
  end
end
