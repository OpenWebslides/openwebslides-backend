# frozen_string_literal: true

class ConversationsController < ApplicationController
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

  # POST /conversations
  def create
    @conversation = Conversation.new conversation_params

    authorize @conversation

    @conversation = Annotations::CreateConversation.call @conversation

    if @conversation.errors.any?
      jsonapi_render_errors :json => @conversation,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @conversation,
                     :status => :created
    end
  end

  # GET /conversations/:id
  def show
    @conversation = Conversation.find params[:id]

    authorize @conversation

    jsonapi_render :json => @conversation
  end

  # PATCH /conversations/:id
  def update
    @conversation = Conversation.find params[:id]

    authorize @conversation
    # TODO: authorize state changes

    @conversation = Annotations::Update.call @conversation, resource_params

    if @conversation.errors.any?
      jsonapi_render_errors :json => @conversation,
                            :status => :unprocessable_entity
    else
      jsonapi_render :json => @conversation
    end
  end

  # DELETE /conversations/:id
  def destroy
    @conversation = Conversation.find params[:id]

    authorize @conversation

    Annotations::Delete.call @conversation

    head :no_content
  end

  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #

  protected

  def conversation_params
    resource_params.merge :user_id => relationship_params[:user],
                          :topic_id => relationship_params[:topic]
  end
end
