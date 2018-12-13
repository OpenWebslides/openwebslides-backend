# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Helpers::Lockable, :type => :helper do
  include Helpers::Lockable

  ##
  # Configuration
  #
  before :all do
    OpenWebslides.configure do |config|
      ##
      # Directory for filesystem locks
      #
      config.lockdir = Dir.mktmpdir
    end

    FileUtils.mkdir_p OpenWebslides.config.lockdir
  end

  ##
  # Subject
  #
  subject(:lockable) { described_class }

  ##
  # Test variables
  #
  let(:topic) { create :topic }

  let(:file) { File.join OpenWebslides.config.lockdir, "#{topic.id}.lock" }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  describe 'unlock' do
    context 'when the block returns successfully' do
      it 'unlocks' do
        read_lock topic do
          # Can lock with shared lock
          expect(file).to lock_with File::LOCK_SH
          # Cannot lock with exclusive lock
          expect(file).not_to lock_with File::LOCK_EX
        end

        # Can lock with exclusive lock (no locks present)
        expect(file).to lock_with File::LOCK_EX
      end
    end

    context 'when the block raises' do
      it 'unlocks' do
        expect do
          read_lock topic do
            # Can lock with shared lock
            expect(file).to lock_with File::LOCK_SH
            # Cannot lock with exclusive lock
            expect(file).not_to lock_with File::LOCK_EX

            raise 'error'
          end
        end.to raise_error 'error'

        # Can lock with exclusive lock (no locks present)
        expect(file).to lock_with File::LOCK_EX
      end
    end
  end

  describe 'read lock' do
    context 'when no locks are present' do
      it 'acquires a lock' do
        expect { |b| read_lock topic, &b }.to yield_control
      end
    end

    context 'when a read lock is present' do
      around do |example|
        read_lock(topic) { example.run }
      end

      it 'acquires a lock' do
        expect { |b| read_lock topic, &b }.to yield_control
      end
    end

    context 'when a write lock is present' do
      around do |example|
        write_lock(topic) { example.run }
      end

      it 'does not acquire a lock' do
        # Specify non-blocking lock, otherwise there's a deadlock
        expect { |b| read_lock topic, File::LOCK_SH | File::LOCK_NB, &b }.not_to yield_control
      end
    end
  end

  describe 'write lock' do
    context 'when no locks are present' do
      it 'acquires a lock' do
        expect { |b| write_lock topic, &b }.to yield_control
      end
    end

    context 'when a read lock is present' do
      around do |example|
        read_lock(topic) { example.run }
      end

      it 'does not acquire a lock' do
        # Specify non-blocking lock, otherwise there's a deadlock
        expect { |b| write_lock topic, File::LOCK_EX | File::LOCK_NB, &b }.not_to yield_control
      end
    end

    context 'when a write lock is present' do
      around do |example|
        write_lock(topic) { example.run }
      end

      it 'does not acquire a lock' do
        # Specify non-blocking lock, otherwise there's a deadlock
        expect { |b| write_lock topic, File::LOCK_EX | File::LOCK_NB, &b }.not_to yield_control
      end
    end
  end
end
