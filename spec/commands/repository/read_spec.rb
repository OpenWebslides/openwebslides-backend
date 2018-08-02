# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Read do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:read_command) { double 'Repository::Filesystem::Read' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    it 'calls Repository::Filesystem::Read' do
      expect(Repository::Filesystem::Read).to receive(:new)
        .with(topic)
        .and_return read_command
      expect(read_command).to receive :execute

      subject.execute
    end
  end
end
