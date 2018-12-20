# frozen_string_literal: true

class MigrateTopicToStateMachine < ActiveRecord::Migration[5.2]
  def change
    Topic.transaction do
      add_column :topics, :access, :string, :null => false, :default => ''

      map_state_to_access = {
        'public_access' => 'public',
        'protected_access' => 'protected',
        'private_access' => 'private',

        0 => 'public',
        1 => 'protected',
        2 => 'private'
      }

      Topic.all.each do |topic|
        topic.update! :access => map_state_to_access[topic.state]

        topic.reload

        raise 'Value is not equal to old value' unless topic.attributes_before_type_cast['access'] == map_state_to_access[topic.state]
        raise 'Value is not legal' unless %w[public protected private].include?(topic.access)
      end

      remove_column :topics, :state
    end
  end
end
