# frozen_string_literal: true

class AddAlertTypeToAlert < ActiveRecord::Migration[5.2]
  def change
    add_column :alerts, :alert_type, :integer, :null => false, :default => 0
  end
end
