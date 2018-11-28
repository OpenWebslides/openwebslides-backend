# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlertPolicy::Scope do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject(:scope) { described_class.new(user, Alert).resolve.count }

  ##
  # Test variables
  #
  let(:user1) { create :user }
  let(:user2) { create :user }

  before do
    create_list :update_alert, 3, :user => user1
    create_list :update_alert, 5, :user => user2
  end

  ##
  # Tests
  #
  context 'when the user is a guest' do
    let(:user) { nil }

    # No alerts
    it { is_expected.to eq 0 }
  end

  context 'when the user is a user' do
    let(:user) { create :user }

    # No alerts
    it { is_expected.to eq 0 }
  end

  context 'when the user is user 1' do
    let(:user) { user1 }

    # Alerts for user 1
    it { is_expected.to eq 3 }
  end

  context 'when the user is user 2' do
    let(:user) { user2 }

    # Alerts for user 1
    it { is_expected.to eq 5 }
  end
end
