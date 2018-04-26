# frozen_string_literal: true

class RemoveCanonicalNameFromTopics < ActiveRecord::Migration[5.2]
  def change
    remove_column :topics, :canonical_name
  end
end
