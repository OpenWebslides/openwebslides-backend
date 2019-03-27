# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JWT::Auth::Authentication
  include Pundit

  # Validate validity of token (if present) on all routes
  before_action :validate_token

  protected

  ##
  # Raises an error if authorization has not been performed, either through a policy or a policy scope
  #
  def verify_authorized_or_policy_scoped
    raise AuthorizationNotPerformedError, self.class unless pundit_policy_authorized? || pundit_policy_scoped?
  end
end
