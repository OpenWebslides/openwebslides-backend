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
      @file.write({ 'version' => OpenWebslides.config.repository.version }.to_yaml)
      @file.close
    end

    it 'raises an error when content is not specified' do
      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'writes the data file'
  end
end
