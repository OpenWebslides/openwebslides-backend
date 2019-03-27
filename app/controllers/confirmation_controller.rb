# frozen_string_literal: true

class ConfirmationController < JSONApiController
  include AddDummyData

  # Authorization
  after_action :verify_authorized

  prepend_before_action :add_dummy_update_id, :only => :update

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
      jsonapi_render :json => @user, :status => :ok, :options => { :resource => UserResource }
    else
      jsonapi_render_errors :json => @user, :status => :unprocessable_entity
    end
  end
end
