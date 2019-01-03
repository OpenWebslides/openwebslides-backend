# frozen_string_literal: true

class RenamePullRequestStateOpenToReady < ActiveRecord::Migration[5.2]
  def change
    PullRequest.where(:state => 'open').each do |pr|
      pr.update_attribute :state, 'ready'
    end
  end
end
