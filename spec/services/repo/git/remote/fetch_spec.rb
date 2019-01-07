# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Git::Remote::Fetch do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Subject
  #
  subject(:service) { described_class }

  ##
  # Test variables
  #
  let(:repo) { Repository.new :topic => create(:topic) }

  let(:name) { 'remote_name' }
  let(:path) { repo.path }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before do
    # Create repository
    FileUtils.mkdir_p repo.path
    `cd #{repo.path} && git init`

    # Add some dummy remotes
    `cd #{repo.path} && git remote add #{name} #{path}`
  end

  it 'fetches a remote by name' do
    service.call repo, name

    # Fetch returns a hash
    expect(service.call repo, name).to include :received_bytes
  end
end
