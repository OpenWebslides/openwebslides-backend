# frozen_string_literal: true

class UsersController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :validate_access_token
  before_action :require_token, :only => %i[update destroy]

  # Authorization
  after_action :verify_authorized, :except => %i[index show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[index show_relationship get_related_resources]

  ##
  # Resource
  #

  # GET /users
  def index
    @users = policy_scope User

    jsonapi_render :json => @users
  end

  # POST /users
  def create
    @user = User.new resource_params

    authorize @user

    @user = Users::Create.call @user

    if @user.errors.any?
      jsonapi_render_errors :json => @user,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @user,
                     :status => :created
    end
  end

  # GET /users/:id
  def show
    @user = User.find params[:id]

    authorize @user

    jsonapi_render :json => @user
  end

  # PUT/PATCH /users/:id
  def update
    @user = User.find params[:id]

    authorize @user

    # If :password is being updated, required :current_password as well
    method = resource_params.include?(:password) ? :update_with_password : :update_without_password

    if @user.send method, resource_params
      jsonapi_render :json => @user
    else
      jsonapi_render_errors :json => @user,
                            :status => :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find params[:id]

    authorize @user

    @user.destroy

    head :no_content
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #
end
