# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequests::Update do
  ##
  # Configuration
  #
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
    context 'when the pull request gets accepted' do
      let(:params) { { :state_event => 'accept', :feedback => 'foo' } }

      it 'persists the pull request to the database' do
        subject.call pull_request, params

        expect(pull_request).to be_persisted
      end

      it 'creates appropriate notifications' do
        expect(Notifications::AcceptPR).to receive(:call).with pull_request

        subject.call pull_request, params
      end
    end

    context 'when the pull request gets rejected' do
      let(:params) { { :state_event => 'reject', :feedback => 'foo' } }

      it 'persists the pull request to the database' do
        subject.call pull_request, params

        expect(pull_request).to be_persisted
      end

      it 'creates appropriate notifications' do
        expect(Notifications::RejectPR).to receive(:call).with pull_request

        subject.call pull_request, params
      end
    end
  end

  context 'when the pull request is invalid' do
    let(:params) { { :state_event => 'reject', :feedback => nil } }

    it 'does not create any notifications' do
      expect(Notifications::RejectPR).not_to receive :call

      subject.call pull_request, params
    end

    describe 'return value' do
      subject { described_class.call pull_request, params }

      it { is_expected.to be_instance_of PullRequest }
      it { is_expected.not_to be_valid }
    end
  end
end
