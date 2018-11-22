# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Copy do
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
  let(:topic) { create :topic }
  let(:fork) { create :topic, :upstream => topic }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    before do
      # Make sure the topic repository is created
      Topics::Create.call topic
    end

    describe 'repository already exists' do
      before do
        # Create the fork repository as well
        Topics::Create.call fork
      end

      it 'raises a RepoExistsError' do
        subject.fork = fork

        expect { subject.execute }.to raise_error OpenWebslides::RepoExistsError
      end
    end

    it 'raises an error when fork is not specified' do
      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'duplicates the repository' do
      subject.fork = fork
      subject.execute

      upstream_content_file = File.join subject.send(:repo_path), 'content.yml'
      downstream_content_file = File.join subject.send(:repo_path, fork), 'content.yml'

      expect(File.exist? downstream_content_file).to be true
      expect(FileUtils.compare_file upstream_content_file, downstream_content_file).to be true
    end
  end
end
