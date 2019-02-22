# frozen_string_literal: true

class TopicsController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :validate_access_token
  before_action :require_token, :only => %i[create update destroy]

  # Authorization
  after_action :verify_authorized, :except => %i[index show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[index get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  ##
  # Resource
  #

  # GET /topics
  def index
    @topics = policy_scope Topic

    jsonapi_render :json => @topics
  end

  # POST /topics
  def create
    @topic = Topic.new topic_params

    authorize @topic

    @topic = Topics::Create.call @topic

    if @topic.errors.any?
      jsonapi_render_errors :json => @topic,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @topic,
                     :status => :created
    end
  end

  # GET /topics/:id
  def show
    @topic = Topic.find params[:id]

    authorize @topic

    jsonapi_render :json => @topic
  end

  # PUT/PATCH /topics/:id
  def update
    @topic = Topic.find params[:id]

    authorize @topic

    if @topic.update resource_params
      jsonapi_render :json => @topic
    else
      jsonapi_render_errors :json => @topic, :status => :unprocessable_entity
    end
  end

  # DELETE /topics/:id
  def destroy
    @topic = Topic.find params[:id]

    authorize @topic

    Topics::Delete.call @topic

    head :no_content
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #

  protected

  def topic_params
    resource_params.merge :user_id => relationship_params[:user]
  end
end
