# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Init do
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
  # Tests
  #
  describe '#execute' do
    it 'raises an error if the directory already exists' do
      # Mock repo_path
      allow(subject).to receive(:repo_path).and_return '/tmp'

      expect(-> { subject.execute }).to raise_error OpenWebslides::RepoExistsError
    end

    it 'creates the repository structure' do
      # Mock repo_path and repo_file
      allow(subject).to receive(:repo_path).and_return directory
      allow(subject).to receive(:repo_file).and_return File.join directory, 'data.json'

      subject.execute

      expect(File).to exist File.join directory, 'data.json'
      expect(File).to exist File.join directory, 'assets', '.keep'
    end
  end
end
