# frozen_string_literal: true

class JSONApiController < ApplicationController
  include JSONAPI::Utils

  include ErrorHandling
  include Versioning

  protected

  ##
  # Request context
  #
  def context
    { :current_user => current_user }
  end

  ##
  # API url for link generation
  #
  def base_url
    @base_url ||= "#{request.protocol}#{request.host_with_port}/api"
  end

  ##
  # Use Pundit authorize a relationship action
  #
  def authorize_relationship(record)
    query = params[:action].gsub('relationship', params[:relationship]) + '?'
    authorize record, query
  end

  ##
  # Use Pundit to authorize an inverse relationship action
  #
  def authorize_inverse_relationship(record)
    # Lookup the inverse association name
    model_klass = controller_name.classify.constantize
    inverse_name = model_klass.reflect_on_association(params[:relationship]).inverse_of&.name.to_s
    return if inverse_name.blank?

    query = params[:action].gsub('relationship', inverse_name) + '?'
    authorize record, query
  end
end
