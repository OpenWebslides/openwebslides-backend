# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertPolicy do
  subject { described_class.new user, record }

  let(:record) { build :alert }

  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :update }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_topic }
    it { is_expected.to forbid_action :show_subject }
    it { is_expected.to forbid_action :show_pull_request }
  end

  context 'when the user is a user' do
    let(:user) { build :user }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :update }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_topic }
    it { is_expected.to forbid_action :show_subject }
    it { is_expected.to forbid_action :show_pull_request }
  end

  context 'when the user is the same' do
    let(:user) { record.user }

    it { is_expected.to permit_action :show }
    it { is_expected.to permit_action :update }

    it { is_expected.to permit_action :show_user }
    it { is_expected.to permit_action :show_topic }
    it { is_expected.to permit_action :show_subject }
    it { is_expected.to permit_action :show_pull_request }
  end
end
