# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Create do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:fs_init_command) { double 'Repository::Filesystem::Init' }
  let(:git_init_command) { double 'Repository::Git::Init' }
  let(:git_commit_command) { double 'Repository::Git::Commit' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    it 'calls Filesystem::Init, Git::Init and Git::Commit with parameters' do
      expect(Repository::Filesystem::Init).to receive(:new)
        .with(topic)
        .and_return fs_init_command
      expect(fs_init_command).to receive :execute

      expect(Repository::Git::Init).to receive(:new)
        .with(topic)
        .and_return git_init_command
      expect(git_init_command).to receive :execute

      expect(Repository::Git::Commit).to receive(:new)
        .with(topic)
        .and_return git_commit_command
      expect(git_commit_command).to receive :execute
      expect(git_commit_command).to receive :author=
      expect(git_commit_command).to receive :message=
      expect(git_commit_command).to receive :params=

      subject.execute
    end
  end
end
