# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Filesystem::WriteIndex do
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

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'writes the version parameter' do
    hash = { 'version' => OpenWebslides.config.repository.version }

    expect(File).to receive(:write).with repo.index, hash.to_yaml

    subject.call repo
  end

  it 'write additional parameters' do
    hash = { 'version' => OpenWebslides.config.repository.version, 'my_config' => 'my_parameter' }

    expect(File).to receive(:write).with repo.index, hash.to_yaml

    subject.call repo, 'my_config' => 'my_parameter'
  end
end
