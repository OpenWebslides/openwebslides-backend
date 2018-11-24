# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedItemPolicy do
  subject { described_class.new user, record }

  let(:record) { build :feed_item, :topic => topic }

  context 'public topics' do
    let(:topic) { create :topic, :access => :public }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'protected topics' do
    let(:topic) { create :topic, :access => :protected }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'private topics' do
    let(:topic) { create :topic, :access => :private }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to permit_action :index }
      it { is_expected.to forbid_action :show }

      it { is_expected.to forbid_action :show_user }
      it { is_expected.to forbid_action :show_topic }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :index }
      it { is_expected.to permit_action :show }

      it { is_expected.to permit_action :show_user }
      it { is_expected.to permit_action :show_topic }
    end
  end
end
