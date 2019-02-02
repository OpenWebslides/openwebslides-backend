# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PullRequests::MergeWorker do
  ##
  # Configuration
  #
  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:pull_request) { create :pull_request, :state => 'ready' }
  let(:user) { create :user }
  let(:message) { "Merge pull request ##{pull_request.id} from #{user.id}/#{pull_request.source.id}" }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'sets the pull request state to accepted' do
    expect(Repo::Merge).to receive(:call)
      .with pull_request.source, pull_request.target, user, message
    expect(Repo::Pull).to receive(:call)
      .with pull_request.target, pull_request.source

    subject.perform pull_request.id, user.id

    pull_request.reload
    expect(pull_request).to be_accepted
  end

  it 'sets the pull request to incompatible when the merge yields conflicts' do
    allow(Repo::Merge).to receive(:call)
      .with(pull_request.source, pull_request.target, user, message)
      .and_raise OpenWebslides::Repo::ConflictsError

    subject.perform pull_request.id, user.id

    pull_request.reload
    expect(pull_request).to be_incompatible
  end
end
