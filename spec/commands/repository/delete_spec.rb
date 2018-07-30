# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Delete do
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:destroy_command) { double 'Repository::Filesystem::Destroy' }

  ##
  # Test subject
  #
  let(:subject) { described_class.new topic }

  ##
  # Tests
  #
  describe '#execute' do
    it 'calls Repository::Filesystem::Destroy' do
      expect(Repository::Filesystem::Destroy).to receive(:new)
        .with(topic)
        .and_return destroy_command
      expect(destroy_command).to receive :execute

      subject.execute
    end
  end
end
