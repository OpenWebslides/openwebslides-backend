# frozen_string_literal: true

RSpec.shared_context 'policy_sample', :shared_context => :metadata do
  before do
    ActiveRecord::Base.transaction do
      u1 = create :user, :confirmed, :name => 'user1'
      u2 = create :user, :confirmed, :name => 'user2'
      u3 = create :user, :confirmed, :name => 'user3'
      u4 = create :user, :confirmed, :name => 'user4'

      # User 1
      create :topic, :with_assets, :with_conversations, :user => u1, :title => 'u1d1'
      create :topic, :with_assets, :with_conversations, :user => u1, :title => 'u1d2', :state => :protected_access
      create :topic, :with_assets, :with_conversations, :user => u1, :title => 'u1d3', :state => :private_access
      user = create :topic, :with_assets, :with_conversations, :user => u1, :title => 'u1d4', :state => :private_access
      user.collaborators << u2
      user.collaborators << u3

      # User 2
      create :topic, :with_assets, :with_conversations, :user => u2, :title => 'u2d1'
      create :topic, :with_assets, :with_conversations, :user => u2, :title => 'u2d2', :state => :protected_access
      create :topic, :with_assets, :with_conversations, :user => u2, :title => 'u2d3', :state => :private_access
      user = create :topic, :with_assets, :with_conversations, :user => u2, :title => 'u2d4', :state => :private_access
      user.collaborators << u1
      user.collaborators << u3

      # User 3
      create :topic, :with_assets, :with_conversations, :user => u3, :title => 'u3d1'
      create :topic, :with_assets, :with_conversations, :user => u3, :title => 'u3d2', :state => :protected_access
      create :topic, :with_assets, :with_conversations, :user => u3, :title => 'u3d3', :state => :private_access
      user = create :topic, :with_assets, :with_conversations, :user => u3, :title => 'u3d4', :state => :private_access
      user.collaborators << u1
      user.collaborators << u2

      # User 4
      create :topic, :with_assets, :with_conversations, :user => u4, :title => 'u4d1'
      create :topic, :with_assets, :with_conversations, :user => u4, :title => 'u4d2', :state => :protected_access
      create :topic, :with_assets, :with_conversations, :user => u4, :title => 'u4d3', :state => :private_access
    end
  end
end
