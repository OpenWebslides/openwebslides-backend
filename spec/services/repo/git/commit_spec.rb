# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Commit do
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
  let(:repository) { Helpers::Committable::Repo.new create(:topic) }

  let(:user) { create :user }
  let(:message) { 'This is a commit message' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    # Create repository
    FileUtils.mkdir_p repo.path
    `cd #{repo.path} && git init && touch .keep && git add --all && git commit -m 'Initial commit'`
  end

  context 'when there are uncommitted changes' do
    before do
      # Make some changes
      `cd #{repo.path} && echo CHANGES > test`
    end

    it 'creates a commit' do
      commit_count = `GIT_DIR=#{File.join repo.path, '.git'} git rev-list --count master`.to_i

      subject.call repo, user, message

      new_commit_count = `GIT_DIR=#{File.join repo.path, '.git'} git rev-list --count master`.to_i

      expect(new_commit_count).to eq commit_count + 1
    end
  end

  context 'when the working tree is clean' do
    it 'raises an EmptyCommitError' do
      expect { subject.call repo, user, message }.to raise_error OpenWebslides::Repo::EmptyCommitError
    end
  end
end
