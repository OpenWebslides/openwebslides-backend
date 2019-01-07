# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Remote::Add do
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
  end

  it 'adds a remote by name' do
    subject.call repo, name, path

    expect(`cd #{repo.path} && git remote`.strip).to eq name
    expect(`cd #{repo.path} && git remote get-url #{name}`.strip).to eq path
  end
end
