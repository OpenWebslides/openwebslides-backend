# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingPolicy do
  subject { described_class.new user, rating }

  let(:rating) { build :rating, :user => user, :annotation => topic.conversations.first }

  context 'for public topics' do
    let(:topic) { build :topic, :with_conversations, :with_collaborators, :state => :public_access }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end
  end

  context 'for protected topics' do
    let(:topic) { build :topic, :with_conversations, :with_collaborators, :state => :protected_access }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end
  end

  context 'for private topics' do
    let(:topic) { build :topic, :with_conversations, :with_collaborators, :state => :private_access }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :destroy }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :destroy }
    end
  end
end
