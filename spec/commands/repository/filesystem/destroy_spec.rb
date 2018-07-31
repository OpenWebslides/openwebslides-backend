# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Destroy do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:directory) { File.join Dir.mktmpdir 'temp' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    before do
      File.write File.join(directory, 'test'), 'foobar'
    end

    it 'deletes the repository and its contents' do
      # Mock repo_path and repo_file
      allow(subject).to receive(:repo_path).and_return directory

      expect(File).to exist File.join directory, 'test'
      subject.execute
      expect(File).not_to exist File.join directory, 'test'
      expect(File).not_to be_directory directory
    end
  end
end
