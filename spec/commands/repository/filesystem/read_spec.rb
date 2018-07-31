# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Filesystem::Read do
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

      @file.write '{"foo":"bar"}'
      @file.close
    end

    it 'reads the data file' do
      # Mock repo_file
      allow(subject).to receive(:repo_file).and_return @file.path

      expect(subject.execute).to eq 'foo' => 'bar'
    end
  end
end
