# frozen-string-literal: true

module AddDummyData
  extend ActiveSupport::Concern

  # Add a dummy `id` attribute to the params, because JSONAPI::Resources does not officially
  # support singleton resources, and requires and `id` to be present when modifying these
  #

  ##
  # Prepend this action to the callback chain when creating a singleton:
  #
  # prepend_before_action :add_dummy_create_id, :only => %i[update]
  def add_dummy_create_id
    params[:data] ||= {}
    params[:data][:id] ||= 0
  end

  ##
  # Prepend this action to the callback chain when updating a singleton:
  #
  # prepend_before_action :add_dummy_update_id, :only => %i[update]
  def add_dummy_update_id
    add_dummy_create_id
  end

  ##
  # Prepend this action to the callback chain when destroying a singleton:
  #
  # prepend_before_action :add_dummy_destroy_id, :only => %i[destroy]
  def add_dummy_destroy_id
    params[:id] ||= 0
  end
end
