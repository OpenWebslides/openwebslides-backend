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

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'sets the pull request state to accepted' do
    expect(Repo::Merge).to receive(:call)
                             .with pull_request.source, pull_request.target

    subject.perform pull_request.id

    pull_request.reload
    expect(pull_request).to be_accepted
  end
end
