# frozen_string_literal: true

class AddLocaleToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :locale, :string, :default => '', :null => false
  end
end
