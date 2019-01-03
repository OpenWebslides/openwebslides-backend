# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Filesystem::Compatible do
  ##
  # Configuration
  #
  include_context 'repository'

  OpenWebslides.configure do |config|
    ##
    # Data format version (semver)
    #
    config.repository.version = '1.0.0'
  end

  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:repo) { build :repository }

  let(:version) { OpenWebslides.config.repository.version }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the repository does not exist' do
    it 'raises a RepoDoesNotExistError' do
      expect { subject.call repo }.to raise_error OpenWebslides::Repo::RepoDoesNotExistError
    end
  end

  context 'when the repository already exists' do
    before do
      FileUtils.mkdir_p repo.content_path

      # Dummy index file
      File.write repo.index, { 'version' => version }.to_yaml
    end

    context 'when the version is too low' do
      let(:version) { '0.1.0' }

      it 'is incompatible' do
        expect(subject.call repo).to be false
      end
    end

    context 'when the version is too high' do
      let(:version) { '2.0.0' }

      it 'is incompatible' do
        expect(subject.call repo).to be false
      end
    end

    context 'when the version is in range' do
      let(:version) { '1.0.0' }

      it 'is incompatible' do
        expect(subject.call repo).to be true
      end
    end
  end
end
