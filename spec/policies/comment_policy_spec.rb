# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class.new user, comment }

  let(:comment) { build :comment, :topic => topic }

  context 'for public topics' do
    let(:topic) { build :topic, :with_collaborators, :state => :public_access }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a user' do
      let(:user) { comment.user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_conversation }
    end
  end

  context 'for protected topics' do
    let(:topic) { build :topic, :with_collaborators, :state => :protected_access }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :show_conversation }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a user' do
      let(:user) { comment.user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_conversation }
    end
  end

  context 'for private topics' do
    let(:topic) { build :topic, :with_collaborators, :state => :private_access }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :show_conversation }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :show_conversation }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a user' do
      before { topic.collaborators << comment.user }

      let(:user) { comment.user }

      it { is_expected.to permit_action :show_conversation }
    end

    context 'for a topic user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :show_conversation }
    end
  end
end
