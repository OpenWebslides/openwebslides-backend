# frozen_string_literal: true

class AddPullRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests do |t|
      t.string :message, :null => false, :default => ''
      t.string :feedback
      t.integer :state

      t.references :user, :foreign_key => true
      t.references :source, :references => :topic
      t.references :target, :references => :topic

      t.timestamps
    end
  end
end
