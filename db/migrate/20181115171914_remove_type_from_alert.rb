# frozen_string_literal: true

class RemoveTypeFromAlert < ActiveRecord::Migration[5.2]
  def change
    remove_column :alerts, :type
  end
end
