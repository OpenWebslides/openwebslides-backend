# frozen_string_literal: true

class TokenController < JSONApiController
  include AddDummyData

  # Authentication
  before_action :validate_refresh_token, :only => %i[update destroy]
  before_action :require_token, :only => %i[update destroy]

  # Authorization
  after_action :verify_authorized

  prepend_before_action :add_dummy_destroy_id, :only => :destroy

  prepend_before_action :add_dummy_update_id, :only => :update
  prepend_before_action :add_dummy_type, :only => :update

  # POST /token
  def create
    @user = User.confirmed.find_by :email => resource_params[:email]&.downcase

    unless @user && @user.valid_password?(resource_params[:password])
      raise JSONAPI::Exceptions::UnauthorizedError.new :create, :token
    end

    authorize :token

    set_refresh_token @user

    jsonapi_render :json => @user,
                   :status => :created,
                   :options => { :resource => UserResource }
  end

  # PATCH /token
  def update
    authorize :token

    set_access_token current_user

    jsonapi_render :json => current_user,
                   :status => :ok,
                   :options => { :resource => UserResource }
  end

  # DELETE /token
  def destroy
    authorize :token

    current_user.increment! :token_version

    head :no_content
  end
end
