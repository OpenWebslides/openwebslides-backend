# frozen_string_literal: true

class MergeFirstNameAndLastNameIntoName < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :name, :string, :default => '', :null => false

    User.transaction do
      User.all.each do |user|
        user.update :name => "#{user.first_name}#{user.last_name ? " #{user.last_name}" : ''}"
      end
    end

    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def self.down
    add_column :users, :first_name, :string, :default => '', :null => false
    add_column :users, :last_name, :string

    User.transaction do
      User.all.each do |user|
        user.update :first_name => user.name
      end
    end

    remove_column :users, :name
  end
end
