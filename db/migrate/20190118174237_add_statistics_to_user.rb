# frozen_string_literal: true

class AddStatisticsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :age, :integer, :null => false, :default => 1
    add_column :users, :gender, :integer, :null => false, :default => 0
    add_column :users, :role, :integer, :null => false, :default => 0
    add_column :users, :country, :string, :null => false, :default => ''
  end
end
