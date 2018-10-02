# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicService do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }
  let(:fork) { create :topic, :upstream => topic }
  let(:user) { create :user }

  let(:fork_command) { double 'Repository::Fork' }

  ##
  # Subject
  #
  subject { described_class.new topic }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  describe '#fork' do
    describe 'upstream is a fork' do
      subject { described_class.new fork }

      it 'returns fork with errors' do
        fork = subject.fork :author => user

        expect(fork).not_to be_nil
        expect(fork).to be_a Topic
        expect(fork).not_to be_persisted
        expect(fork).not_to be_valid
        expect(fork.errors).not_to be_empty
      end
    end

    it 'returns fork' do
      expect(Repository::Fork).to receive(:new)
        .with(topic)
        .and_return fork_command
      expect(fork_command).to receive(:fork=)
      expect(fork_command).to receive :execute

      fork = subject.fork :author => user

      expect(fork).not_to be_nil
      expect(fork).to be_a Topic
      expect(fork).to be_persisted
      expect(fork).to be_valid

      expect(fork.upstream).to eq topic
      expect(fork.user).to eq user
    end
  end
end
