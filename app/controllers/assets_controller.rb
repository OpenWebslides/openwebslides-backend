# frozen_string_literal: true

class AssetsController < ApplicationController
  include BinaryUploadable
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[create destroy]

  # Authorization
  after_action :verify_authorized, :except => %i[show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  upload_action :create

  skip_before_action :jsonapi_request_handling, :only => :raw

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

  # DELETE /assets/:id
  def destroy
    @asset = Asset.find params[:id]

    authorize @asset

    Assets::Delete.call @asset, current_user

    head :no_content
  end

  # GET /assets/:id/raw
  def raw
    @asset = Asset.find params[:asset_id]
    return head :not_found unless @asset

    # Authenticate from ?token=
    token = Asset::Token.from_token params[:token]

    # Set @jwt for compatibility with jwt-auth's current_user for #authorize
    @jwt = JWT::Auth::Token.from_user token.subject

    authorize @asset, :show?
    return head :unauthorized unless token && token.valid?

    # Send file
    send_file Assets::Find.call @asset
  end
end
