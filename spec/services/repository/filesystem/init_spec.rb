# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Init do
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

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the repository does not exist' do
    it 'creates the repository structure' do
      described_class.call repo

      expect(File).to exist File.join repo.path, 'content.yml'
      expect(File).to exist File.join repo.path, 'assets', '.keep'
      expect(File).to exist File.join repo.path, 'content', '.keep'
    end
  end

  context 'when the repository already exists' do
    before { described_class.call repo }

    it 'raises a RepoExistsError' do
      expect { described_class.call repo }.to raise_error OpenWebslides::RepoExistsError
    end
  end
end
