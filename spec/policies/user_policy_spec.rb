# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new user, record }

  let(:record) { build :user }

  context 'for a guest' do
    let(:user) { nil }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }
    it { is_expected.to permit_action :show }
    it { is_expected.to forbid_action :update }
    it { is_expected.to forbid_action :destroy }

    it { is_expected.to permit_action :show_decks }
    it { is_expected.to permit_action :show_collaborations }
    it { is_expected.to permit_action :show_notifications }
    it { is_expected.to permit_action :show_annotations }
  end

  context 'for a user' do
    let(:user) { build :user }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }
    it { is_expected.to permit_action :show }
    it { is_expected.to forbid_action :update }
    it { is_expected.to forbid_action :destroy }

    it { is_expected.to permit_action :show_decks }
    it { is_expected.to permit_action :show_collaborations }
    it { is_expected.to permit_action :show_notifications }
    it { is_expected.to permit_action :show_annotations }
  end

  context 'for the same user' do
    let(:user) { record }

    it { is_expected.to permit_action :index }
    it { is_expected.to permit_action :create }
    it { is_expected.to permit_action :update }
    it { is_expected.to permit_action :destroy }

    it { is_expected.to permit_action :show_decks }
    it { is_expected.to permit_action :show_collaborations }
    it { is_expected.to permit_action :show_notifications }
    it { is_expected.to permit_action :show_annotations }
  end
end
