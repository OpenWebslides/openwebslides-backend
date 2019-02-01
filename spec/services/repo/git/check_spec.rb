# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Check do
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
    it 'returns true' do
      expect(subject.call repo, commit).to be true
    end
  end

  context 'when there is a conflict' do
    before do
      # Create conflicting update on master
      `cd #{repo.path} && echo test3 > test && git add test && git commit -m 'Update to test3'`
    end

    it 'returns false' do
      expect(subject.call repo, commit).to be false
    end
  end
end
