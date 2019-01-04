# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo::Filesystem::Fork do
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
  let(:fork) { Repository.new :topic => create(:topic, :upstream => repo.topic) }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the upstream repository does not exist' do
    it 'raises a RepoDoesNotExistError' do
      expect { subject.call repo, fork }.to raise_error OpenWebslides::Repo::RepoDoesNotExistError
    end
  end

  context 'when the downstream repository exists' do
    before do
      Repo::Create.call repo.topic
      Repo::Create.call fork.topic
    end

    it 'raises a RepoExistsError' do
      expect { subject.call repo, fork }.to raise_error OpenWebslides::Repo::RepoExistsError
    end
  end

  context 'when the upstream repository exists' do
    before { Repo::Create.call repo.topic }

    it 'duplicates the repository' do
      subject.call repo, fork

      expect(File).to be_directory fork.path
      expect(File).to exist File.join repo.path, 'content.yml'
      expect(File).to exist File.join repo.path, 'assets', '.keep'
      expect(File).to exist File.join repo.path, 'content', '.keep'

      expect(Dir[repo.path]).to eq Dir[repo.path]
    end
  end
end
