# frozen_string_literal: true

class ContentController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[update]
  after_action :renew_token

  prepend_before_action :add_dummy_id

  ##
  # Resource
  #

  # GET /topics/:id/content
  def show
    @topic = Topic.find params[:topic_id]

    authorize @topic

    jsonapi_render :json => @topic
  end

  # PUT/PATCH /topics/:id/content
  def update
    @topic = Topic.find params[:topic_id]

    authorize @topic

    content = resource_params[:content].permit!.to_h
    service.update :author => current_user, :content => content

    head :no_content
  rescue JSON::ParserError
    jsonapi_render_bad_request
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #

  protected

  def service
    TopicService.new @topic
  end

  def add_dummy_id
    # JSONAPI::Resources requires an :id attribute
    params[:data] ||= {}
    params[:data][:id] = 0
  end
end
