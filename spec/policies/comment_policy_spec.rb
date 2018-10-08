# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class.new user, comment }

  let(:comment) { build :comment, :topic => topic }

  context 'when a topic is public' do
    let(:topic) { build :topic, :with_collaborators, :state => :public_access }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a user' do
      let(:user) { comment.user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_conversation }
    end
  end

  context 'when a topic is protected' do
    let(:topic) { build :topic, :with_collaborators, :state => :protected_access }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :show_conversation }
    end

    context 'when the user is a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a user' do
      let(:user) { comment.user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_conversation }
    end
  end

  context 'when a topic is private' do
    let(:topic) { build :topic, :with_collaborators, :state => :private_access }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :show_conversation }
    end

    context 'when the user is a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :show_conversation }
    end

    context 'when the user is a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a user' do
      before { topic.collaborators << comment.user }

      let(:user) { comment.user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'when the user is a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_conversation }
    end
  end
end
