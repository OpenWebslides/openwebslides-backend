# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequests::Create do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:pull_request) { build :pull_request }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the pull_request is valid' do
    it 'persists the pull_request to the database' do
      subject.call pull_request

      expect(pull_request).to be_persisted
    end

    it 'creates appropriate notifications' do
      expect(Notifications::CreatePR).to receive(:call).with pull_request

      subject.call pull_request
    end
  end

  context 'when the pull_request is invalid' do
    let(:pull_request) { build :pull_request, :user => nil }

    it 'does not persist the pull_request to the database' do
      expect(pull_request).not_to be_persisted

      subject.call pull_request
    end

    it 'does not create any notifications' do
      expect(Notifications::CreatePR).not_to receive :call

      subject.call pull_request
    end

    describe 'return value' do
      subject { described_class.call pull_request }

      it { is_expected.to be_instance_of Pull_request }
      it { is_expected.not_to be_valid }
    end
  end
end
