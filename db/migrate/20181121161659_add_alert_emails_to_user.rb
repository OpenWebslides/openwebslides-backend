# frozen_string_literal: true

class AddAlertEmailsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :alert_emails, :boolean, :null => false, :default => true
  end
end
