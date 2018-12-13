# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Write do
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
  let(:repo) { Helpers::Committable::Repo.new create(:topic, :root_content_item_id => 'qyrgv0bcd6') }

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
      'subItemIds' => ['oswmjc09be']
    }
    paragraph = {
      'id' => 'oswmjc09be',
      'type' => 'contentItemTypes/PARAGRAPH',
      'text' => 'This is a paragraph',
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
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repository::Create.call repo.topic }

  it 'raises an error when no root content item is present' do
    expect { subject.call repo, content.drop(1) }.to raise_error OpenWebslides::Content::NoRootContentItemError
  end

  it 'raises an error when the root content item does not match the database' do
    expect { subject.call repo, [root_content_item] }.to raise_error OpenWebslides::Content::InvalidRootContentItemError
  end

  it 'validates the repository version' do
    expect(Repository::Filesystem::Compatible).to receive(:call).with repo

    subject.call repo, content
  end

  it 'writes the index' do
    expect(Repository::Filesystem::WriteIndex).to receive(:call).with repo, 'root' => 'qyrgv0bcd6'

    subject.call repo, content
  end

  it 'writes the content' do
    subject.call repo, content

    expect(Dir.entries repo.content_path).to include 'qyrgv0bcd6.yml', 'ivks4jgtxr.yml', 'oswmjc09be.yml'
  end

  describe '#write_content_item' do
    subject { described_class.new }

    before { subject.repo = repo }

    it 'raises an error when no id is present' do
      expect { subject.send :write_content_item, content.first.without('id') }.to raise_error OpenWebslides::Content::InvalidContentItemError
    end

    it 'writes the content file' do
      path = File.join repo.content_path, 'qyrgv0bcd6.yml'
      string = "---\nid: qyrgv0bcd6\ntype: contentItemTypes/ROOT\nchildItemIds:\n- ivks4jgtxr\n"

      expect(File).to receive(:write).with path, string

      subject.send :write_content_item, content.first
    end
  end

  describe '#cleanup_content' do
    subject { described_class.new }

    before { subject.repo = repo }

    context 'when content items stay the same' do
      it 'does not remove any files' do
        allow(Dir).to receive(:[])
          .and_return %w[qyrgv0bcd6 ivks4jgtxr oswmjc09be]

        expect(FileUtils).not_to receive :rm

        subject.send :cleanup_content, content
      end
    end

    context 'when content items are added' do
      it 'does not remove any files' do
        allow(Dir).to receive(:[])
          .and_return %w[qyrgv0bcd6 ivks4jgtxr]

        expect(FileUtils).not_to receive :rm

        subject.send :cleanup_content, content
      end
    end

    context 'when content items are removed' do
      it 'calls FileUtils#rm' do
        allow(Dir).to receive(:[])
          .and_return %w[qyrgv0bcd6 ivks4jgtxr oswmjc09be rv4njc3oin]

        expect(FileUtils).to receive(:rm)
          .with File.join(repo.content_path, 'rv4njc3oin.yml')

        subject.send :cleanup_content, content
      end
    end
  end
end
