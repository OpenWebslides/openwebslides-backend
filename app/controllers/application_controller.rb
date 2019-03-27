# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JWT::Auth::Authentication
  include Pundit

  # Validate validity of token (if present) on all routes
  before_action :validate_token
end
