# frozen_string_literal: true

class TokenController < ApplicationController
  include AddDummyId

  # Authentication
  before_action :authenticate_user, :only => :destroy

  # Authorization
  after_action :verify_authorized

  prepend_before_action :add_dummy_destroy_id, :only => :destroy

  # POST /token
  def create
    @user = User.find_by :email => resource_params[:email].downcase

    unless @user && @user.valid_password?(resource_params[:password])
      raise JSONAPI::Exceptions::UnauthorizedError.new :create, :token
    end
    raise JSONAPI::Exceptions::UnconfirmedError unless @user.confirmed?

    authorize :token

    token = JWT::Auth::Token.from_user @user
    headers['Authorization'] = "Bearer #{token.to_jwt}"

    jsonapi_render :json => @user, :status => :created, :options => { :resource => UserResource }
  end

  # DELETE /token
  def destroy
    authorize :token

    current_user.increment_token_version!

    head :no_content
  end
end
