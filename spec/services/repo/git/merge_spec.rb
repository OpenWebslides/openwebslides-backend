# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Merge do
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
  let(:repo) { Repository.new :topic => create(:topic) }

  let(:user) { create :user }
  let(:commit) { `cd #{repo.path} && git rev-parse mybranch`.strip }
  let(:message) { 'Merging repository' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    # Create repository
    FileUtils.mkdir_p repo.path
    `cd #{repo.path} && git init && echo test1 > test && git add test && git commit -m 'Initial commit'`

    # Create branch to merge from
    `cd #{repo.path} && git checkout -b mybranch && echo test2 > test && git add test && git commit -m 'Update to test2'; git checkout master`
  end

  context 'when there are no conflicts' do
    it 'merges the commit into master using a merge commit' do
      subject.call repo, commit, user, message

      # 4 commits: Initial commit, update commit and merge commit
      expect(`cd #{repo.path} && git rev-list --count master`.to_i).to eq 3
      expect(`cd #{repo.path} && cat test`.strip).to eq 'test2'
    end

    it 'has the merge message and the current user as author' do
      subject.call repo, commit, user, message

      expect(`cd #{repo.path} && git log --format=%B -n 1 HEAD`.strip).to eq message
      expect(`cd #{repo.path} && git log --format=%ae -n 1 HEAD`.strip).to eq user.email
    end
  end

  context 'when there is a conflict' do
    before do
      # Create conflicting update on master
      `cd #{repo.path} && echo test3 > test && git add test && git commit -m 'Update to test3'`
    end

    it 'raises a ConflictsError' do
      expect { subject.call repo, commit, user, message }.to raise_error OpenWebslides::Repo::ConflictsError
    end
  end
end
