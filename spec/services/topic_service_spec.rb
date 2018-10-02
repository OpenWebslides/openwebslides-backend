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

      it 'returns false' do
        new_fork = topic.dup
        result = subject.fork :author => user, :fork => new_fork

        expect(result).to be false

        expect(new_fork).not_to be_persisted
        expect(new_fork).not_to be_valid
        expect(new_fork.errors).not_to be_empty
      end
    end

    it 'returns fork' do
      new_fork = topic.dup

      expect(Repository::Fork).to receive(:new)
        .with(topic)
        .and_return fork_command
      expect(fork_command).to receive(:fork=)
      expect(fork_command).to receive :execute

      result = subject.fork :author => user, :fork => new_fork

      expect(result).to be true

      expect(new_fork).to be_persisted
      expect(new_fork).to be_valid

      expect(new_fork.upstream).to eq topic
      expect(new_fork.user).to eq user
    end
  end
end
