# frozen_string_literal: true

class AddDeviceTypeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :device_type, :integer
  end
end
