# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, rating }

  ##
  # Test variables
  #
  let(:rating) { build :rating, :user => user, :annotation => topic.conversations.first }

  ##
  # Tests
  #
  context 'when the topic is public' do
    let(:topic) { build :topic, :with_conversations, :with_collaborators, :access => :public }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'when the user is a topic owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end
  end

  context 'when the topic is protected' do
    let(:topic) { build :topic, :with_conversations, :with_collaborators, :access => :protected }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'when the user is a topic owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end
  end

  context 'when the topic is private' do
    let(:topic) { build :topic, :with_conversations, :with_collaborators, :access => :private }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'when the user is a topic owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end
  end
end
