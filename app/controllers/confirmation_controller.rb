# frozen_string_literal: true

class ConfirmationController < ApplicationController
  # Authorization
  after_action :verify_authorized

  # POST /confirmation
  def create
    authorize :confirmation

    User.send_confirmation_instructions :email => resource_params[:email]

    # Never return any errors to prevent email probing
    head :no_content
  end

  # PUT/PATCH /confirmation
  def update
    authorize :confirmation

    @user = User.confirm_by_token resource_params[:confirmation_token]

    if @user.errors.empty?
      jsonapi_render :json => @user, :status => :created, :options => { :resource => UserResource }
    else
      jsonapi_render_errors :json => @user, :status => :unprocessable_entity
    end
  end
end
