# frozen_string_literal: true

class AlertsController < JSONApiController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :validate_access_token
  before_action :require_token

  # Authorization
  after_action :verify_authorized, :except => %i[show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  ##
  # Resource
  #

  # GET /alerts/:id
  def show
    @alert = Alert.find params[:id]

    authorize @alert

    jsonapi_render :json => @alert
  end

  # PUT/PATCH /alerts/:id
  def update
    @alert = Alert.find params[:id]

    authorize @alert

    if @alert.update resource_params
      jsonapi_render :json => @alert
    else
      jsonapi_render_errors :json => @alert, :status => :unprocessable_entity
    end
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #
end
