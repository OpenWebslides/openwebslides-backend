# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new user, record }

  let(:record) { build :user }

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }
    it { is_expected.to permit_action :show }
    it { is_expected.to forbid_action :update }
    it { is_expected.to forbid_action :destroy }

    it { is_expected.to permit_action :show_topics }
    it { is_expected.to permit_action :show_collaborations }
    it { is_expected.to permit_action :show_feed_items }
    it { is_expected.to permit_action :show_annotations }
    it { is_expected.to forbid_action :show_alerts }
  end

  context 'when the user is a user' do
    let(:user) { build :user }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }
    it { is_expected.to permit_action :show }
    it { is_expected.to forbid_action :update }
    it { is_expected.to forbid_action :destroy }

    it { is_expected.to permit_action :show_topics }
    it { is_expected.to permit_action :show_collaborations }
    it { is_expected.to permit_action :show_feed_items }
    it { is_expected.to permit_action :show_annotations }
    it { is_expected.to forbid_action :show_alerts }
  end

  context 'when the user is the same' do
    let(:user) { record }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }
    it { is_expected.to permit_action :update }
    it { is_expected.to permit_action :destroy }

    it { is_expected.to permit_action :show_topics }
    it { is_expected.to permit_action :show_collaborations }
    it { is_expected.to permit_action :show_feed_items }
    it { is_expected.to permit_action :show_annotations }
    it { is_expected.to permit_action :show_alerts }
  end
end
