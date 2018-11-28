# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Delete do
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
    it 'raises a RepoDoesNotExistError' do
      expect { subject.call repo }.to raise_error OpenWebslides::RepoDoesNotExistError
    end
  end

  context 'when the repository already exists' do
    before { Repository::Create.call repo.topic }

    it 'deletes the repository structure' do
      subject.call repo

      expect(File).not_to exist repo.path
    end
  end
end
