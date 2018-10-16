# frozen_string_literal: true

##
# Wrap related resource actions to provide authorization
#
module RelatedResources
  extend ActiveSupport::Concern

  # GET /klass/:klass_id/:relationship (e.g. /topics/:topic_id/user)
  def get_related_resource
    model_klass = safe_constantize_source params[:source]

    id = params["#{params[:source].singularize}_id"]
    @resource = model_klass.find id

    # Find association on model class
    association = ([params[:relationship]] & model_klass.reflections.keys)&.first

    @relationship = @resource.send association

    # Authorize RELATIONSHIP_CLASS#show_RELATIONSHIP? (e.g. TopicPolicy#show_user?)
    authorize @resource, "show_#{association}?"

    # Authorize INVERSE_RELATIONSHIP_CLASS#show? (e.g. UserPolicy#show?)
    authorize @relationship, :show?

    jsonapi_render :json => @relationship
  end

  # GET /klass/:klass_id/:relationship (e.g. /users/:user_id/topics)
  def get_related_resources
    model_klass = safe_constantize_source params[:source]

    id = params["#{params[:source].singularize}_id"]
    @resource = model_klass.find id

    # Find association on model class
    association = ([params[:relationship]] & model_klass.reflections.keys)&.first

    # Authorize MODEL#show_RELATIONSHIP? (e.g. UserPolicy#show_topics?)
    authorize @resource, "show_#{association}?"

    # Authorize INVERSE_RELATIONSHIP_CLASS::Policy (e.g. TopicPolicy::Scope)
    @resources = policy_scope @resource.send association

    jsonapi_render :json => @resources
  end

  private

  ##
  # Safely constantize a relationship string
  #
  def safe_constantize_source(source)
    source_klass = source.classify
    klasses = ApplicationRecord.descendants.map(&:to_s) & [source_klass]

    klasses&.first&.constantize
  end
end
