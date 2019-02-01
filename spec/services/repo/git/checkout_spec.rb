# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Checkout do
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

  let(:commit) { `cd #{repo.path} && git rev-parse mybranch`.strip }

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

    # Create branch to checkout from
    `cd #{repo.path} && git checkout -b mybranch && echo test2 > test && git add test && git commit -m 'Update to test2'; git checkout master`
  end

  context 'when there are no conflicts' do
    it 'updates the master branch to the commit' do
      subject.call repo, commit

      # 2 commits: Initial commit, update commit
      expect(`cd #{repo.path} && git rev-list --count master`.to_i).to eq 2
      expect(`cd #{repo.path} && cat test`.strip).to eq 'test2'
      expect(`cd #{repo.path} && git diff-index --quiet HEAD; echo $?`.to_i).to eq 0
    end
  end
end
