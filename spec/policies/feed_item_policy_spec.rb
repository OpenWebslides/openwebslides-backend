# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItemPolicy do
  subject { described_class.new user, record }

  let(:record) { build :feed_item, :topic => topic }

  context 'when the topic is public' do
    let(:topic) { create :topic, :state => 'public_access' }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'when the topic is protected' do
    let(:topic) { create :topic, :state => 'protected_access' }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'when the topic is private' do
    let(:topic) { create :topic, :state => 'private_access' }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is a user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end
end
