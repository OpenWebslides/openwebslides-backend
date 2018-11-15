# frozen_string_literal: true

class ContentController < ApplicationController
  include Relationships
  include RelatedResources
  include AddDummyData

  # Authentication
  before_action :authenticate_user, :only => %i[update]
  after_action :renew_token

  prepend_before_action :add_dummy_update_id, :only => %i[update]

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

    content = resource_params[:content].map { |p| p.permit!.to_hash }
    params = {
      :author => current_user,
      :content => content,
      :message => resource_params[:message]
    }

    if service.update params
      head :no_content
    else
      jsonapi_render_errors :json => @topic, :status => :unprocessable_entity
    end
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
end
