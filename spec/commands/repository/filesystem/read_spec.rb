# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Read do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:directory) { File.join Dir.mktmpdir('temp'), 'repository' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Stubs
  #
  before do
    # Mock repo_path
    allow(subject).to receive(:repo_path).and_return directory
  end

  ##
  # Tests
  #
  describe '#execute' do
    describe 'repository does not exist' do
      let(:directory) { '/foo/bar' }

      it 'raises a RepoDoesNotExistError' do
        expect { subject.execute }.to raise_error OpenWebslides::RepoDoesNotExistError
      end
    end

    describe 'existing repository' do
      before do
        FileUtils.mkdir_p subject.send(:content_path)

        # Dummy index file
        index_hash = {
          'version' => OpenWebslides.config.repository.version,
          'root' => 'j0vcu0y7vk'
        }
        File.write subject.send(:index_file), index_hash.to_yaml

        # Dummy content items
        content_item_hash = {
          'id' => 'j0vcu0y7vk',
          'foo' => 'bar'
        }
        File.write File.join(subject.send(:content_path), 'j0vcu0y7vk.yml'), content_item_hash.to_yaml
      end

      it 'reads the data files' do
        result = subject.execute

        expect(result).not_to be_nil # TODO
      end
    end
  end
end
