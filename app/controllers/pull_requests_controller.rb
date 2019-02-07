# frozen_string_literal: true

class PullRequestsController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[show]

  # Authorization
  after_action :verify_authorized, :except => %i[show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  ##
  # Resource
  #

  # GET /pullRequests/:id
  def show
    @pull_request = PullRequest.find params[:id]

    authorize @pull_request

    jsonapi_render :json => @pull_request
  end

  # POST /pullRequests
  def create
    @pull_request = PullRequest.new pull_request_params

    authorize @pull_request

    @pull_request = PullRequests::Create.call @pull_request

    if @pull_request.errors.any?
      jsonapi_render_errors :json => @pull_request,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @pull_request,
                     :status => :created
    end
  end

  # PUT/PATCH /users/:id
  def update
    @pull_request = PullRequest.find params[:id]

    authorize @pull_request

    @pull_request = PullRequests::Update.call @pull_request, resource_params, current_user

    if @pull_request.errors.any?
      jsonapi_render_errors :json => @pull_request,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @pull_request
    end
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #

  protected

  def pull_request_params
    resource_params.merge :user_id => relationship_params[:user],
                          :source_id => relationship_params[:source],
                          :target_id => relationship_params[:target]
  end
end
