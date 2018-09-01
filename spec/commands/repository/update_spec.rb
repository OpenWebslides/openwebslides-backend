# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Update do
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:user) { create :user }

  let(:fs_write_command) { double 'Repository::Filesystem::Write' }
  let(:git_commit_command) { double 'Repository::Git::Commit' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    it 'raises ArgumentError when no author is specified' do
      subject.content = 'foobar'
      subject.message = 'foobar'

      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'raises ArgumentError when no content is specified' do
      subject.author = user
      subject.message = 'foobar'

      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'raises ArgumentError when no message is specified' do
      subject.content = 'foobar'
      subject.author = user

      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'does not raise anything when author, content and message are specified' do
      subject.author = user
      subject.content = 'foobar'
      subject.message = 'foobar'

      # Stub execute methods
      allow_any_instance_of(Repository::Filesystem::Write).to receive :execute
      allow_any_instance_of(Repository::Git::Commit).to receive :execute

      expect { subject.execute }.not_to raise_error
    end

    it 'calls Filesystem::Write and Git::Commit with parameters' do
      expect(Repository::Filesystem::Write).to receive(:new)
        .with(topic)
        .and_return fs_write_command
      expect(fs_write_command).to receive :execute
      expect(fs_write_command).to receive(:content=).with 'content'

      expect(Repository::Git::Commit).to receive(:new)
        .with(topic)
        .and_return git_commit_command
      expect(git_commit_command).to receive :execute
      expect(git_commit_command).to receive(:author=).with user
      expect(git_commit_command).to receive(:message=).with 'message'

      subject.author = user
      subject.content = 'content'
      subject.message = 'message'
      subject.execute
    end
  end
end
