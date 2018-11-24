# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConversationPolicy do
  subject { described_class.new user, conversation }

  let(:conversation) { build :conversation, :topic => topic }

  context 'for public topics' do
    let(:topic) { build :topic, :with_collaborators, :access => :public }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a user' do
      let(:user) { conversation.user }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_comments }
    end
  end

  context 'for protected topics' do
    let(:topic) { build :topic, :with_collaborators, :access => :protected }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :show_comments }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a user' do
      let(:user) { conversation.user }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_comments }
    end
  end

  context 'for private topics' do
    let(:topic) { build :topic, :with_collaborators, :access => :private }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :show_comments }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :show_comments }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a user' do
      before { topic.collaborators << conversation.user }
      let(:user) { conversation.user }

      it { is_expected.to permit_action :show_comments }
    end

    context 'for a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_comments }
    end
  end
end
