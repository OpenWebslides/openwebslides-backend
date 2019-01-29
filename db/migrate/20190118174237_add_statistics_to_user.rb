# frozen_string_literal: true

class AddStatisticsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :age, :integer
    add_column :users, :gender, :integer
    add_column :users, :role, :integer
    add_column :users, :country, :string
  end
end
