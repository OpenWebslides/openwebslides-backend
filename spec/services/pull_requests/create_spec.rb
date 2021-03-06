# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequests::Create do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the pull request is valid' do
    it 'persists the pull request to the database' do
      allow(PullRequests::CheckWorker).to receive(:perform_async)

      subject.call pull_request

      expect(pull_request).to be_persisted
    end

    it 'dispatches a background job' do
      expect(PullRequests::CheckWorker).to receive(:perform_async).with pull_request.id

      subject.call pull_request
    end

    it 'creates appropriate notifications' do
      allow(PullRequests::CheckWorker).to receive(:perform_async)
      expect(Notifications::SubmitPR).to receive(:call).with pull_request

      subject.call pull_request
    end
  end

  context 'when the pull request is invalid' do
    let(:pull_request) { build :pull_request, :user => nil }

    it 'does not persist the pull request to the database' do
      expect(pull_request).not_to be_persisted

      subject.call pull_request
    end

    it 'does not dispatch a background job' do
      expect(PullRequests::CheckWorker).not_to receive :perform_async

      subject.call pull_request
    end

    it 'does not create any notifications' do
      expect(Notifications::SubmitPR).not_to receive :call

      subject.call pull_request
    end

    describe 'return value' do
      subject { described_class.call pull_request }

      it { is_expected.to be_instance_of PullRequest }
      it { is_expected.not_to be_valid }
    end
  end
end
