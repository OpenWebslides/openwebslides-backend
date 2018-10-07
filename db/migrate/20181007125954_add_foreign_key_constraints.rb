# frozen_string_literal: true

class AddForeignKeyConstraints < ActiveRecord::Migration[5.2]
  def change
    ##
    # Add missing foreign key constraints in the database
    #
    # Commented out lines are foreign keys that should already be present in the database from previous migrations
    #

    # Annotations
    # add_foreign_key :annotations, :users
    add_foreign_key :annotations, :topics
    add_foreign_key :annotations, :annotations, :column => 'conversation_id'

    # Assets
    # add_foreign_key :assets, :topics

    # Feed Items
    # add_foreign_key :feed_items, :users
    # add_foreign_key :feed_items, :topics

    # Grants
    add_foreign_key :grants, :users
    add_foreign_key :grants, :topics

    # Identities
    # add_foreign_key :identities, :users

    # Ratings
    add_foreign_key :ratings, :users

    # Topics
    # add_foreign_key :topics, :users
  end
end
