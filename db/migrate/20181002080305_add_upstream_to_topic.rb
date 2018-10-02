# frozen_string_literal: true

class AddUpstreamToTopic < ActiveRecord::Migration[5.2]
  def change
    # add_reference :topics, :topics, :foreign_key => 'upstream_id'
    # add_reference :topics, :upstream, :foreign_key => { :to_table => :topics }
    add_reference :topics, :upstream, :references => :topics
    # change_table :topics do |t|
    #   t.references :upstream, :references => :topics
    # end
  end
end
