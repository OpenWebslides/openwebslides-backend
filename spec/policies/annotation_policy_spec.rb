# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnotationPolicy do
  subject { described_class.new user, annotation }

  let(:annotation) { build :annotation, :topic => topic }

  context 'when a topic is public' do
    let(:topic) { build :topic, :with_collaborators, :state => :public_access }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a collaborator' do
      before { annotation.user = user }

      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a user' do
      let(:user) { annotation.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a topic user' do
      before { annotation.user = user }

      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end
  end

  context 'when a topic is protected' do
    let(:topic) { build :topic, :with_collaborators, :state => :protected_access }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to forbid_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a collaborator' do
      before { annotation.user = user }

      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a user' do
      let(:user) { annotation.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a topic user' do
      before { annotation.user = user }

      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end
  end

  context 'when a topic is private' do
    let(:topic) { build :topic, :with_collaborators, :state => :private_access }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to forbid_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }
      it { is_expected.to forbid_action :flag }

      it { is_expected.to forbid_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a collaborator' do
      before { annotation.user = user }

      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a user' do
      before { topic.collaborators << annotation.user }

      let(:user) { annotation.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end

    context 'when the user is a topic user' do
      before { annotation.user = user }

      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }
      it { is_expected.to permit_action :flag }

      it { is_expected.to permit_action :show_topic }
      it { is_expected.to permit_action :show_user }
    end
  end
end
