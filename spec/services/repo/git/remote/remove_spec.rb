# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Remote::Remove do
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

  let(:name) { 'remote_name' }
  let(:path) { '/path/to/remote.git' }

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
    `cd #{repo.path} && git remote add #{name} #{path}`
  end

  it 'removes a remote by name' do
    subject.call repo, name

    expect(`cd #{repo.path} && git remote`).to be_empty
    expect(`cd #{repo.path} && git remote get-url #{name}`).to be_empty
  end
end
