# frozen_string_literal: true

class RenameDecksToTopics < ActiveRecord::Migration[5.1]
  def change
    # Rename tables
    rename_table :decks, :topics

    # Rename references
    rename_column :annotations, :deck_id, :topic_id
    rename_column :assets, :deck_id, :topic_id
    rename_column :grants, :deck_id, :topic_id
    rename_column :notifications, :deck_id, :topic_id
  end
end
