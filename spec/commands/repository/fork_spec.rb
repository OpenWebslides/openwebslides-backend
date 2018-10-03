# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Fork do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:fs_copy_command) { double 'Repository::Filesystem::Copy' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    it 'raises ArgumentError when no fork is specified' do
      expect { subject.execute }.to raise_error OpenWebslides::ArgumentError
    end

    it 'calls Filesystem::Copy with parameters' do
      expect(Repository::Filesystem::Copy).to receive(:new)
        .with(topic)
        .and_return fs_copy_command
      expect(fs_copy_command).to receive(:fork=).with 'fork'
      expect(fs_copy_command).to receive :execute

      subject.fork = 'fork'

      subject.execute
    end
  end
end
