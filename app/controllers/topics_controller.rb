# frozen_string_literal: true

class TopicsController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[create update destroy]
  after_action :renew_token

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
    begin
      @topic = Topic.new topic_params
    rescue ArgumentError
      # FIXME: Topic.new throws ArgumentError when :state is invalid
      # See https://github.com/rails/rails/issues/13971#issuecomment-287030984
      @topic = Topic.new topic_params.merge :state => ''
      invalid_state = true
    end

    authorize @topic

    if service.create
      jsonapi_render :json => @topic, :status => :created
    else
      # Explicitly add errors here, because @topic.errors gets cleared on #save
      @topic.errors.add :state, 'is invalid' if invalid_state
      jsonapi_render_errors :json => @topic, :status => :unprocessable_entity
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
  rescue ArgumentError
    # Add error to catch invalid state
    @topic.errors.add :state, 'is invalid'
    jsonapi_render_errors :json => @topic, :status => :unprocessable_entity
  end

  # DELETE /topics/:id
  def destroy
    @topic = Topic.find params[:id]

    authorize @topic

    service.delete

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

  def service
    TopicService.new @topic
  end
end
