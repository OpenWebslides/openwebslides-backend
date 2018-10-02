# frozen_string_literal: true

class ForkController < ApplicationController
  include AddDummyData

  # Authentication
  before_action :authenticate_user
  after_action :renew_token

  # Authorization
  after_action :verify_authorized

  prepend_before_action :add_dummy_type, :only => %i[create]

  ##
  # Resource
  #

  # POST /fork
  def create
    @topic = Topic.find params[:topic_id]

    authorize @topic, :fork?

    @fork = @topic.dup

    params = {
      :author => current_user,
      :fork => @fork
    }

    if service.fork params
      jsonapi_render :json => @fork,
                     :status => :created,
                     :options => { :resource => TopicResource }
    else
      jsonapi_render_errors :json => @fork,
                            :status => :unprocessable_entity
    end
  end

  protected

  def service
    TopicService.new @topic
  end
end
