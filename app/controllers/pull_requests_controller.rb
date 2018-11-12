# frozen_string_literal: true

class PullRequestsController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[show]
  after_action :renew_token

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

    if @pull_request.save
      jsonapi_render :json => @pull_request, :status => :created
    else
      jsonapi_render_errors :json => @pull_request, :status => :unprocessable_entity
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
