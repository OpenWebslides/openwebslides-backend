# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Git::Commit do
  ##
  # Configuration
  #
  around do |example|
    temp_dir = Dir.mktmpdir

    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = temp_dir
    end

    example.run

    FileUtils.rm_rf temp_dir
  end

  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:repo) { Helpers::Committable::Repo.new create(:topic) }

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

      described_class.call repo, user, message

      new_commit_count = `GIT_DIR=#{File.join repo.path, '.git'} git rev-list --count master`.to_i

      expect(new_commit_count).to eq commit_count + 1
    end
  end

  context 'when the working tree is clean' do
    it 'raises an EmptyCommitError' do
      expect { described_class.call repo, user, message }.to raise_error OpenWebslides::EmptyCommitError
    end
  end
end
