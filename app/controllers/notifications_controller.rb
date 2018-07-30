# frozen_string_literal: true

class NotificationsController < ApplicationController
  # Authentication
  after_action :renew_token

  # Authorization
  after_action :verify_authorized, :except => %i[index]
  after_action :verify_policy_scoped, :only => %i[index]

  ##
  # Resource
  #

  # GET /notifications
  def index
    @notifications = policy_scope Notification

    jsonapi_render :json => @notifications
  end
end
