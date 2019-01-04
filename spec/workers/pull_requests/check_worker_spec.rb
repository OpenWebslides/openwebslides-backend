# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequests::CheckWorker do
  ##
  # Configuration
  #
  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request, :state => 'pending' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the pull request source is compatible with the target' do
    it 'sets the pull request state to ready' do
      expect(Repo::Check).to receive(:call)
        .with(pull_request.source, pull_request.target)
        .and_return true

      subject.perform pull_request.id

      pull_request.reload
      expect(pull_request).to have_attributes :state => 'ready'
    end
  end

  context 'when the pull request source is incompatible with the target' do
    it 'sets the pull request state to incompatible' do
      expect(Repo::Check).to receive(:call)
        .with(pull_request.source, pull_request.target)
        .and_return false

      subject.perform pull_request.id

      pull_request.reload
      expect(pull_request).to have_attributes :state => 'incompatible'
    end
  end
end
