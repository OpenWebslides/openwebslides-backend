# frozen-string-literal: true

module AddDummyId
  extend ActiveSupport::Concern

  # Add a dummy `id` attribute to the params, because JSONAPI::Resources does not officially
  # support singleton resources, and requires and `id` to be present when modifying these
  #
  # Prepend this action to the callback chain:
  #
  # prepend_before_action :add_dummy_update_id, :only => %i[update]
  def add_dummy_update_id
    params[:data] ||= {}
    params[:data][:id] ||= 0
  end

  # Prepend this action to the callback chain:
  #
  # prepend_before_action :add_dummy_destroy_id, :only => %i[destroy]
  def add_dummy_destroy_id
    params[:id] ||= 0
  end
end
