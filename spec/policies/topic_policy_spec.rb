# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicPolicy do
  subject { described_class.new user, topic }

  let(:topic) { build :topic, :state => :public_access, :user => user }

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to permit_action :index }
    it { is_expected.to forbid_action :create }

    it 'does not permit :create when the user is just a user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'when a topic is public' do
      let(:topic) { build :topic, :state => :public_access }

      it 'permits only read' do
        expect(subject).to permit_action :show
        expect(subject).to forbid_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to forbid_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to forbid_action :show_incoming_pull_requests
        expect(subject).to forbid_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is protected' do
      let(:topic) { build :topic, :state => :protected_access }

      it 'does not permit anything' do
        expect(subject).to forbid_action :show
        expect(subject).to forbid_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to forbid_action :fork

        expect(subject).to forbid_action :show_user
        expect(subject).to forbid_action :show_upstream
        expect(subject).to forbid_action :show_forks
        expect(subject).to forbid_action :show_collaborators
        expect(subject).to forbid_action :show_assets
        expect(subject).to forbid_action :show_feed_items
        expect(subject).to forbid_action :show_conversations
        expect(subject).to forbid_action :show_annotations
        expect(subject).to forbid_action :show_incoming_pull_requests
        expect(subject).to forbid_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is private' do
      let(:topic) { build :topic, :state => :private_access }

      it 'does not permit anything' do
        expect(subject).to forbid_action :show
        expect(subject).to forbid_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to forbid_action :fork

        expect(subject).to forbid_action :show_user
        expect(subject).to forbid_action :show_upstream
        expect(subject).to forbid_action :show_forks
        expect(subject).to forbid_action :show_collaborators
        expect(subject).to forbid_action :show_assets
        expect(subject).to forbid_action :show_feed_items
        expect(subject).to forbid_action :show_conversations
        expect(subject).to forbid_action :show_annotations
        expect(subject).to forbid_action :show_incoming_pull_requests
        expect(subject).to forbid_action :show_outgoing_pull_requests
      end
    end
  end

  context 'when the user is a user' do
    let(:user) { build :user }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }

    it 'does not permit :create when the user is just a user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'when a topic is public' do
      let(:topic) { build :topic, :state => :public_access }

      it 'permits only read' do
        expect(subject).to permit_action :show
        expect(subject).to forbid_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to forbid_action :show_incoming_pull_requests
        expect(subject).to forbid_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is protected' do
      let(:topic) { build :topic, :state => :protected_access }

      it 'permits only read' do
        expect(subject).to permit_action :show
        expect(subject).to forbid_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to forbid_action :show_incoming_pull_requests
        expect(subject).to forbid_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is private' do
      let(:topic) { build :topic, :state => :private_access }

      it 'does not permit anything' do
        expect(subject).to forbid_action :show
        expect(subject).to forbid_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to forbid_action :fork

        expect(subject).to forbid_action :show_user
        expect(subject).to forbid_action :show_upstream
        expect(subject).to forbid_action :show_forks
        expect(subject).to forbid_action :show_collaborators
        expect(subject).to forbid_action :show_assets
        expect(subject).to forbid_action :show_feed_items
        expect(subject).to forbid_action :show_conversations
        expect(subject).to forbid_action :show_annotations
        expect(subject).to forbid_action :show_incoming_pull_requests
        expect(subject).to forbid_action :show_outgoing_pull_requests
      end
    end
  end

  context 'when the user is a collaborator' do
    let(:user) { build :user, :with_topics }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }

    it 'does not permit :create when the user is just a user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'when a topic is public' do
      let(:topic) { build :topic, :with_collaborators, :state => :public_access }
      let(:user) { topic.collaborators.first }

      it 'permits update' do
        expect(subject).to permit_action :show
        expect(subject).to permit_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to permit_action :show_incoming_pull_requests
        expect(subject).to permit_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is protected' do
      let(:topic) { build :topic, :with_collaborators, :state => :protected_access }
      let(:user) { topic.collaborators.first }

      it 'does not permit anything' do
        expect(subject).to permit_action :show
        expect(subject).to permit_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to permit_action :show_incoming_pull_requests
        expect(subject).to permit_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is private' do
      let(:topic) { build :topic, :with_collaborators, :state => :private_access }
      let(:user) { topic.collaborators.first }

      it 'does not permit anything' do
        expect(subject).to permit_action :show
        expect(subject).to permit_action :update
        expect(subject).to forbid_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to permit_action :show_incoming_pull_requests
        expect(subject).to permit_action :show_outgoing_pull_requests
      end
    end
  end

  context 'when the user is an owner' do
    let(:user) { build :user, :with_topics }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }

    it 'does not permit :create when the user is just a user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'when a topic is public' do
      let(:topic) { build :topic, :state => :public_access }
      let(:user) { topic.user }

      it 'permits everything' do
        expect(subject).to permit_action :show
        expect(subject).to permit_action :update
        expect(subject).to permit_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to permit_action :show_incoming_pull_requests
        expect(subject).to permit_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is protected' do
      let(:topic) { build :topic, :state => :protected_access }
      let(:user) { topic.user }

      it 'permits everything' do
        expect(subject).to permit_action :show
        expect(subject).to permit_action :update
        expect(subject).to permit_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to permit_action :show_incoming_pull_requests
        expect(subject).to permit_action :show_outgoing_pull_requests
      end
    end

    context 'when a topic is private' do
      let(:topic) { build :topic, :state => :private_access }
      let(:user) { topic.user }

      it 'permits everything' do
        expect(subject).to permit_action :show
        expect(subject).to permit_action :update
        expect(subject).to permit_action :destroy
        expect(subject).to permit_action :fork

        expect(subject).to permit_action :show_user
        expect(subject).to permit_action :show_upstream
        expect(subject).to permit_action :show_forks
        expect(subject).to permit_action :show_collaborators
        expect(subject).to permit_action :show_assets
        expect(subject).to permit_action :show_feed_items
        expect(subject).to permit_action :show_conversations
        expect(subject).to permit_action :show_annotations
        expect(subject).to permit_action :show_incoming_pull_requests
        expect(subject).to permit_action :show_outgoing_pull_requests
      end
    end
  end
end
