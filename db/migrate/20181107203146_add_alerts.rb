# frozen_string_literal: true

class AddAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :alerts do |t|
      ##
      # Common columns
      #
      t.references :user, :foreign_key => true
      t.boolean :read, :null => false, :default => false

      t.timestamps

      ##
      # STI column
      #
      t.string :type

      ##
      # UpdateAlert
      #
      t.integer :count
      t.references :topic, :foreign_key => true
    end
  end
end
