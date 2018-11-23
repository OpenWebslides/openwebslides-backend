# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicPolicy do
  subject { described_class.new user, topic }

  let(:topic) { build :topic, :access => 'public', :user => user }

  context 'for a guest' do
    let(:user) { nil }

    it { is_expected.to permit_action :index }
    it { is_expected.to forbid_action :create }

    it 'should not permit :create for another user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'for public topics' do
      let(:topic) { build :topic, :access => 'public' }
      it 'should permit only read' do
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

    context 'for protected topics' do
      let(:topic) { build :topic, :access => 'protected' }
      it 'should not permit anything' do
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

    context 'for private topics' do
      let(:topic) { build :topic, :access => 'private' }
      it 'should not permit anything' do
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

  context 'for a user' do
    let(:user) { build :user }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }

    it 'should not permit :create for another user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'for public topics' do
      let(:topic) { build :topic, :access => 'public' }
      it 'should permit only read' do
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

    context 'for protected topics' do
      let(:topic) { build :topic, :access => 'protected' }
      it 'should permit only read' do
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

    context 'for private topics' do
      let(:topic) { build :topic, :access => 'private' }
      it 'should not permit anything' do
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

  context 'for a collaborator' do
    let(:user) { build :user, :with_topics }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }

    it 'should not permit :create for another user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'for public topics' do
      let(:topic) { build :topic, :with_collaborators, :access => 'public' }
      let(:user) { topic.collaborators.first }
      it 'should permit update' do
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

    context 'for protected topics' do
      let(:topic) { build :topic, :with_collaborators, :access => 'protected' }
      let(:user) { topic.collaborators.first }
      it 'should not permit anything' do
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

    context 'for private topics' do
      let(:topic) { build :topic, :with_collaborators, :access => 'private' }
      let(:user) { topic.collaborators.first }
      it 'should not permit anything' do
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

  context 'for an owner' do
    let(:user) { build :user, :with_topics }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }

    it 'should not permit :create for another user' do
      expect(described_class.new(build(:user), topic)).to forbid_action :create
    end

    context 'for public topics' do
      let(:topic) { build :topic, :access => 'public' }
      let(:user) { topic.user }
      it 'should permit everything' do
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

    context 'for protected topics' do
      let(:topic) { build :topic, :access => 'protected' }
      let(:user) { topic.user }
      it 'should permit everything' do
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

    context 'for private topics' do
      let(:topic) { build :topic, :access => 'private' }
      let(:user) { topic.user }
      it 'should permit everything' do
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
