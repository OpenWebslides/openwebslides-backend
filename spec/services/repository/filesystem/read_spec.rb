# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Read do
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
      expect { subject.call repo }.to raise_error OpenWebslides::Repo::RepoDoesNotExistError
    end
  end

  context 'when the repository already exists' do
    subject { described_class.call repo }

    before do
      FileUtils.mkdir_p repo.content_path

      # Dummy index file
      index_hash = {
        'version' => OpenWebslides.config.repository.version,
        'root' => 'j0vcu0y7vk'
      }
      File.write repo.index, index_hash.to_yaml

      # Dummy content items
      content_item_hash = {
        'id' => 'j0vcu0y7vk',
        'foo' => 'bar'
      }
      File.write File.join(repo.content_path, 'j0vcu0y7vk.yml'), content_item_hash.to_yaml
    end

    it { is_expected.to eq [{ 'id' => 'j0vcu0y7vk', 'foo' => 'bar' }] }
  end
end
