# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Git::Init do
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
    it 'calls Rugged' do
      # Mock repo_path and repo_file
      allow(subject).to receive(:repo_path).and_return '/tmp'

      expect(Rugged::Repository).to receive(:init_at).with '/tmp'

      subject.execute
    end
  end
end
