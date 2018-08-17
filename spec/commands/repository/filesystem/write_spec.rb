# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Write do
  ##
  # Configuration
  #
  before :each do
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
  let(:topic) { create :topic, :root_content_item_id => 'qyrgv0bcd6' }

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

  let(:root_content_item) do
    {
      'id' => Faker::Lorem.words(3).join(''),
      'type' => 'contentItemTypes/ROOT',
      'childItemIds' => []
    }
  end

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    before :each do
      service = TopicService.new topic

      # Make sure the topic repository is created
      service.create
    end

    it 'raises an error when content is not specified' do
      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'writes the index file' do
      subject.content = content
      subject.execute

      index_str = "---\nroot: qyrgv0bcd6\nversion: #{OpenWebslides.config.repository.version}\n"
      expect(File.read subject.send(:index_file)).to eq index_str
    end

    it 'writes the content' do
      subject.content = content
      subject.execute

      content_item_ids = Dir[File.join subject.send(:content_path), '*.yml'].map { |f| File.basename f, '.yml' }
      expect(content_item_ids).to match_array %w[qyrgv0bcd6 ivks4jgtxr oswmjc09be]
    end
  end

  describe '#validate_root_content_item_id' do
    it 'raises an error when root content item id does not match the database' do
      expect { subject.send :validate_root_content_item_id, root_content_item }.to raise_error OpenWebslides::FormatError
    end

    it 'returns when root content item id matches the database' do
      expect { subject.send :validate_root_content_item_id, content.first }.not_to raise_error
    end
  end

  describe '#write_content_item' do
    it 'raises an error when no id is present' do
      expect { subject.send :write_content_item, content.first.without('id') }.to raise_error OpenWebslides::FormatError
    end

    it 'writes the content item file' do
      content_file = File.join subject.send(:content_path), 'qyrgv0bcd6.yml'
      content_str = "---\nid: qyrgv0bcd6\ntype: contentItemTypes/ROOT\nchildItemIds:\n- ivks4jgtxr\n"

      expect(File).to receive(:write)
        .with content_file, content_str

      subject.send :write_content_item, content.first
    end
  end

  describe '#cleanup_content' do
    before :each do
      subject.content = content
    end

    describe 'when content items stay the same' do
      it 'does not call FileUtils#rm' do
        allow(Dir).to receive(:[])
          .and_return %w[qyrgv0bcd6 ivks4jgtxr oswmjc09be]

        expect(FileUtils).not_to receive :rm

        subject.send :cleanup_content
      end
    end

    describe 'when content items are added' do
      it 'does not call FileUtils#rm' do
        allow(Dir).to receive(:[])
          .and_return %w[qyrgv0bcd6 ivks4jgtxr]

        expect(FileUtils).not_to receive :rm

        subject.send :cleanup_content
      end
    end

    describe 'when content items are removed' do
      it 'calls FileUtils#rm' do
        allow(Dir).to receive(:[])
          .and_return %w[qyrgv0bcd6 ivks4jgtxr oswmjc09be rv4njc3oin]

        expect(FileUtils).to receive(:rm)
          .with File.join(subject.send(:content_path), 'rv4njc3oin.yml')

        subject.send :cleanup_content
      end
    end
  end
end
