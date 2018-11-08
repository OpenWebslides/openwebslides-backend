# frozen_string_literal: true

class AlertsController < ApplicationController
  include Relationships
  include RelatedResources

  # Authentication
  before_action :authenticate_user, :only => %i[show]
  after_action :renew_token

  # Authorization
  after_action :verify_authorized, :except => %i[show_relationship get_related_resources]
  after_action :verify_policy_scoped, :only => %i[get_related_resources]
  after_action :verify_authorized_or_policy_scoped, :only => :show_relationship

  ##
  # Resource
  #
  ##
  # Relationships
  #
  # Relationships and related resource actions are implemented in the respective concerns
  #
end
