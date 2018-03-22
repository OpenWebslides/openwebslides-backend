# frozen_string_literal: true

class RenameTopicNameToTitle < ActiveRecord::Migration[5.1]
  def change
    rename_column :topics, :name, :title
  end
end
