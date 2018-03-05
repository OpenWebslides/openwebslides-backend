# frozen_string_literal: true

class RenameDecksToTopics < ActiveRecord::Migration[5.1]
  def change
    # Rename table
    rename_table :decks, :topics
    rename_index :topics, :index_decks_on_user_id, :index_topics_on_user_id

    # Rename foreign indices
    rename_column :annotations, :deck_id, :topic_id
    rename_index :annotations, :index_annotations_on_deck_id, :index_annotations_on_topic_id

    rename_column :assets, :deck_id, :topic_id
    rename_index :assets, :index_assets_on_deck_id, :index_assets_on_topic_id

    rename_column :grants, :deck_id, :topic_id
    rename_index :grants, :index_grants_on_deck_id_and_user_id, :index_grants_on_topic_id_and_user_id
    rename_index :grants, :index_grants_on_deck_id, :index_grants_on_topic_id
    rename_index :grants, :index_grants_on_user_id_and_deck_id, :index_grants_on_user_id_and_topic_id

    rename_column :notifications, :deck_id, :topic_id
    rename_index :notifications, :index_notifications_on_deck_id, :index_notifications_on_topic_id
  end
end
