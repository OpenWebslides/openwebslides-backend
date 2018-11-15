# frozen_string_literal: true

class AddPullRequestAlert < ActiveRecord::Migration[5.2]
  def change
    add_reference :alerts, :pull_request
    add_reference :alerts, :subject, :references => :users
  end
end
