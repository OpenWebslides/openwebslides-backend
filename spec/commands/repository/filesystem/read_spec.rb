# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Read do
  ##
  # Configuration
  #
  before do
    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = Dir.mktmpdir
    end
  end

  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:content) do
    root = {
      'id' => 'qyrgv0bcd6',
      'type' => 'contentItemTypes/ROOT',
      'childItemIds' => ['ivks4jgtxr']
    }
    heading = {
      'id' => 'ivks4jgtxr',
      'type' => 'contentItemTypes/HEADING',
      'text' => 'This is a heading',
      'metadata' => { 'tags' => [], 'visibilityOverrides' => {} },
      'subItemIds' => ['oswmjc09be']
    }
    paragraph = {
      'id' => 'oswmjc09be',
      'type' => 'contentItemTypes/PARAGRAPH',
      'text' => 'This is a paragraph',
      'metadata' => { 'tags' => [], 'visibilityOverrides' => {} },
      'subItemIds' => []
    }

    [root, heading, paragraph]
  end

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    describe 'repository does not exist' do
      let(:directory) { '/foo/bar' }

      it 'raises a RepoDoesNotExistError' do
        expect { subject.execute }.to raise_error OpenWebslides::Repo::RepoDoesNotExistError
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

        expect(result).to eq [{ 'id' => 'j0vcu0y7vk', 'foo' => 'bar' }]
      end
    end
  end
end
