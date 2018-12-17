# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Log do
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
  let(:message) { 'This is a commit message' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    # Create repository and some commits
    FileUtils.mkdir_p repo.path
    `cd #{repo.path} && git init && echo A > test && git add --all && git commit -m 'Initial commit' && echo B > test && git add --all && git commit -m 'Second commit' && echo C > test && git add --all && git commit -m 'Third commit'`
  end

  it 'returns the commit oids from old to new' do
    commits = `cd #{repo.path} && git log --pretty=format:"%H" --reverse`.split("\n")

    expect(subject.call repo).to eq commits
  end
end
