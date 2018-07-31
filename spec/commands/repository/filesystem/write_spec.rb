# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Write do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    before do
      @file = Tempfile.new
      @file.close
    end

    it 'raises an error when content is not specified' do
      expect(-> { subject.execute }).to raise_error OpenWebslides::ArgumentError
    end

    it 'writes the data file' do
      # Mock repo_file
      allow(subject).to receive(:repo_file).and_return @file.path

      subject.content = { :foo => 'bar' }
      subject.execute

      expect(File.read @file.path).to eq "{\n  \"foo\": \"bar\"\n}\n"
    end
  end
end
