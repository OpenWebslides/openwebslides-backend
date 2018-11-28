# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItemPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, feed_item }

  ##
  # Test variables
  #
  let(:feed_item) { build :feed_item, :topic => topic }

  ##
  # Tests
  #
  context 'when the topic is public' do
    let(:topic) { create :topic, :access => :public }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'when the topic is protected' do
    let(:topic) { create :topic, :access => :protected }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'when the topic is private' do
    let(:topic) { create :topic, :access => :private }

    context 'when the user is a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is just a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'when the user is a topic owner' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end
end
