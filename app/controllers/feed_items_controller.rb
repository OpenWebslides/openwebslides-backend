# frozen_string_literal: true

class FeedItemsController < ApplicationController
  # Authentication
  after_action :renew_token

  # Authorization
  after_action :verify_authorized, :except => %i[index]
  after_action :verify_policy_scoped, :only => %i[index]

  ##
  # Resource
  #

  # GET /feedItems
  def index
    @feed_items = policy_scope FeedItem

    jsonapi_render :json => @feed_items
  end
end
