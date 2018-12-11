# frozen_string_literal: true

class RenameFeedItemEventTypeToFeedItemType < ActiveRecord::Migration[5.2]
  def change
    rename_column :feed_items, :event_type, :feed_item_type
  end
end
