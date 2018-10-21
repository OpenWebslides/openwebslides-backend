# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::YAMLCommand do
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
  it 'has a valid content_path' do
    expect(subject.send :content_path).to eq File.join subject.send(:repo_path), 'content'
  end

  it 'has a valid index_file' do
    expect(subject.send :index_file).to eq File.join subject.send(:repo_path), 'content.yml'
  end

  describe '#validate_version' do
    it 'satisfies the exact version' do
      # Stub out File#read
      allow(File).to receive(:read)
        .and_return("version: #{OpenWebslides.config.repository.version}")

      expect { subject.send :validate_version }.not_to raise_error
    end

    it 'does not satisfy an incompatible version' do
      incompatible_version = Semverse::Version.new '0.0.0'

      # Stub out File#read
      allow(File).to receive(:read)
        .and_return("version: #{incompatible_version}")

      expect { subject.send :validate_version }.to raise_error OpenWebslides::Content::IncompatibleVersionError
    end
  end

  describe '#write_version' do
    it 'writes the data format version' do
      expect(File).to receive(:write)
        .with subject.send(:index_file), "---\nversion: #{OpenWebslides.config.repository.version}\n"

      subject.send :write_index
    end

    it 'writes the data format version and other attributes' do
      index_str = "---\nroot: foobar\nversion: #{OpenWebslides.config.repository.version}\n"
      expect(File).to receive(:write)
        .with subject.send(:index_file), index_str

      subject.send :write_index, 'root' => 'foobar'
    end
  end
end
