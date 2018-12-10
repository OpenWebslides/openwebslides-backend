# frozen_string_literal: true

class ChangeTypeOfPullRequestState < ActiveRecord::Migration[5.2]
  def change
    change_column :pull_requests, :state, :string, :null => false, :default => ''
  end
end
