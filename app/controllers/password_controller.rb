# frozen_string_literal: true

class PasswordController < ApplicationController
  include AddDummyData

  # Authorization
  after_action :verify_authorized

  prepend_before_action :add_dummy_update_id, :only => %i[update]

  # POST /password
  def create
    authorize :password

    User.send_reset_password_instructions :email => resource_params[:email]

    # Never return errors to prevent email probing
    head :no_content
  end

  # PUT/PATCH /password
  def update
    authorize :password

    @user = User.reset_password_by_token resource_params

    if @user.errors.empty?
      jsonapi_render :json => @user, :status => :ok, :options => { :resource => UserResource }
    else
      jsonapi_render_errors :json => @user, :status => :unprocessable_entity
    end
  end
end
