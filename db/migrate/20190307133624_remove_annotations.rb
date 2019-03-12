# frozen_string_literal: true

class RemoveAnnotations < ActiveRecord::Migration[5.2]
  def change
    drop_table :ratings
    drop_table :annotations
  end
end
