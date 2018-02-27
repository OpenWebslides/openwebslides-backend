# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :event_type
      t.references :user, :foreign_key => true
      t.references :deck, :foreign_key => true

      t.timestamps
    end
  end
end
