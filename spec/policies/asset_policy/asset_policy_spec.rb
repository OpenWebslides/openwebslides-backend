# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, asset }

  ##
  # Test variables
  #
  let(:asset) { topic.assets.first }

  ##
  # Tests
  #
  context 'when the topic is public' do
    let(:topic) { build :topic, :with_assets, :with_collaborators, :access => :public }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is an owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'when the topic is protected' do
    let(:topic) { build :topic, :with_assets, :with_collaborators, :access => :protected }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is an owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'when the topic is private' do
    let(:topic) { build :topic, :with_assets, :with_collaborators, :access => :private }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is an owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :raw }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end
  end
end
