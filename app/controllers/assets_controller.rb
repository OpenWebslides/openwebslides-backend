# frozen_string_literal: true

class AssetsController < ApplicationController
  include BinaryUploadable
  include Relationships
  include RelatedResources

  include ContentTypeHelper

  # Authentication
  before_action :validate_access_token
  before_action :require_token, :only => %i[create destroy]

  # Authorization
  after_action :verify_authorized, :except => %i[show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  upload_action :create

  skip_after_action :add_content_type_header_version, :only => :raw

  # POST /assets
  def create
    @topic = Topic.find params[:topic_id]
    @asset = Asset.new :topic => @topic,
                       :filename => File.basename(uploaded_filename)

    authorize @asset

    @asset = Assets::Create.call @asset, current_user, uploaded_file

    if @asset.errors.any?
      jsonapi_render_errors :json => @asset,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @asset,
                     :status => :created
    end
  end

  # GET /assets/:id
  def show
    @asset = Asset.find params[:id]

    authorize @asset

    jsonapi_render :json => @asset
  end

  # GET /assets/:id
  def raw
    @topic = Topic.find params[:topic_id]
    @asset = @topic&.assets.find_by! :filename => params[:filename]

    authorize @asset, :raw?


    # Send file
    send_file Assets::Find.call(@asset), :type => content_type_for(@asset.filename)
  end

  # DELETE /assets/:id
  def destroy
    @asset = Asset.find params[:id]

    authorize @asset

    Assets::Delete.call @asset, current_user

    head :no_content
  end
end
