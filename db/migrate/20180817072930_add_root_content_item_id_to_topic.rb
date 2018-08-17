# frozen_string_literal: true

class AddRootContentItemIdToTopic < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :root_content_item_id, :string
  end
end
