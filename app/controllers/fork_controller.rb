# frozen_string_literal: true

class ForkController < JSONApiController
  include AddDummyData

  # Authentication
  before_action :validate_access_token
  before_action :require_token

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

    @fork = Topics::Fork.call @topic, current_user

    if @fork.errors.any?
      jsonapi_render_errors :json => @fork,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @fork,
                     :status => :created,
                     :options => { :resource => TopicResource }
    end
  end
end
