# frozen_string_literal: true

class AddTemplateToDecks < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :template, :string
  end
end
