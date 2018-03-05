# frozen_string_literal: true

class RemoveTemplateFromTopic < ActiveRecord::Migration[5.1]
  def change
    remove_column :topics, :template
  end
end
