# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequests::Update do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request, :source => fork, :target => topic, :state => 'ready' }
  let(:user) { create :user }

  let(:topic) { create :topic, :user => user }
  let(:fork) { create :topic, :upstream => topic, :root_content_item_id => topic.root_content_item_id }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    # Create the upstream repository
    Repo::Create.call topic

    # Fork the repository
    Repo::Fork.call topic, fork
  end

  context 'when the pull request is valid' do
    context 'when the pull request gets accepted' do
      let(:params) { { :state_event => 'accept', :feedback => 'foo' } }

      it 'persists the pull request to the database' do
        subject.call pull_request, params, user

        expect(pull_request).to be_persisted
      end

      it 'dispatches a background job to merge the pull request' do
        expect(PullRequests::MergeWorker).to receive(:perform_async).with pull_request.id, user.id

        subject.call pull_request, params, user
      end

      it 'creates appropriate notifications' do
        expect(Notifications::AcceptPR).to receive(:call).with pull_request

        subject.call pull_request, params, user
      end
    end

    context 'when the pull request gets rejected' do
      let(:params) { { :state_event => 'reject', :feedback => 'foo' } }

      it 'persists the pull request to the database' do
        subject.call pull_request, params, user

        expect(pull_request).to be_persisted
      end

      it 'creates appropriate notifications' do
        expect(Notifications::RejectPR).to receive(:call).with pull_request

        subject.call pull_request, params, user
      end
    end
  end

  context 'when the pull request is invalid' do
    let(:params) { { :state_event => 'reject', :feedback => nil } }

    it 'does not create any notifications' do
      expect(Notifications::RejectPR).not_to receive :call

      subject.call pull_request, params, user
    end

    describe 'return value' do
      subject { described_class.call pull_request, params, user }

      it { is_expected.to be_instance_of PullRequest }
      it { is_expected.not_to be_valid }
    end
  end
end
