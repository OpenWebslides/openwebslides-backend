# frozen_string_literal: true

class RenameNotificationToFeedItem < ActiveRecord::Migration[5.2]
  def change
    rename_table :notifications, :feed_items
  end
end
