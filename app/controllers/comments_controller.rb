# frozen_string_literal: true

class CommentsController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[create update destroy]
  after_action :renew_token

  # Authorization
  after_action :verify_authorized, :except => %i[show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  ##
  # Resource
  #

  # POST /comments
  def create
    @comment = Comment.new comment_params

    authorize @comment

    @comment = Annotations::CreateComment.call @comment

    if @comment.errors.any?
      jsonapi_render_errors :json => @comment,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @comment,
                     :status => :created
    end
  end

  # GET /comments/:id
  def show
    @comment = Comment.find params[:id]

    authorize @comment

    jsonapi_render :json => @comment
  end

  # PATCH /comments/:id
  def update
    @comment = Comment.find params[:id]

    authorize @comment
    # TODO: authorize state change

    @comment = Annotations::Update.call @comment, resource_params

    if @comment.errors.any?
      jsonapi_render_errors :json => @comment,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @comment
    end
  end

  # DELETE /comments/:id
  def destroy
    @comment = Comment.find params[:id]

    authorize @comment

    Annotations::Delete.call @comment

    head :no_content
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #

  protected

  def comment_params
    resource_params.merge :user_id => relationship_params[:user],
                          :topic_id => relationship_params[:topic],
                          :conversation_id => relationship_params[:conversation]
  end
end
