# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequestAlert, :type => :model do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  subject(:alert) { create :pull_request_alert }

  ##
  # Tests
  #
  it { is_expected.to be_valid }

  describe 'attributes' do
    context 'when the alert type is not topic_updated' do
      before { alert.alert_type = :topic_updated }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:subject).class_name('User') }
    it { is_expected.to belong_to(:pull_request) }
  end
end
