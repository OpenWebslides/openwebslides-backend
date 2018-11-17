# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertPolicy do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:policy) { described_class.new user, alert }

  ##
  # Test variables
  #
  let(:alert) { build :alert }

  ##
  # Tests
  #
  context 'when the user is a guest' do
    let(:user) { nil }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :update }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_topic }
    it { is_expected.to forbid_action :show_subject }
    it { is_expected.to forbid_action :show_pull_request }
  end

  context 'when the user is just a user' do
    let(:user) { build :user }

    it { is_expected.to forbid_action :show }
    it { is_expected.to forbid_action :update }

    it { is_expected.to forbid_action :show_user }
    it { is_expected.to forbid_action :show_topic }
    it { is_expected.to forbid_action :show_subject }
    it { is_expected.to forbid_action :show_pull_request }
  end

  context 'when the user is an owner' do
    let(:user) { alert.user }

    it { is_expected.to permit_action :show }
    it { is_expected.to permit_action :update }

    it { is_expected.to permit_action :show_user }
    it { is_expected.to permit_action :show_topic }
    it { is_expected.to permit_action :show_subject }
    it { is_expected.to permit_action :show_pull_request }
  end
end
