# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Init do
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
  let(:repo) { Helpers::Committable::Repo.new create(:topic) }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the repository does not exist' do
    it 'creates the repository structure' do
      subject.call repo

      expect(File).to exist File.join repo.path, 'content.yml'
      expect(File).to exist File.join repo.path, 'assets', '.keep'
      expect(File).to exist File.join repo.path, 'content', '.keep'
    end
  end

  context 'when the repository already exists' do
    before { subject.call repo }

    it 'raises a RepoExistsError' do
      expect { subject.call repo }.to raise_error OpenWebslides::RepoExistsError
    end
  end
end
