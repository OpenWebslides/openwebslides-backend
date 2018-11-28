# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Create do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Subject
  #
  ##
  # Test variables
  #
  let(:topic) { build :topic }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  context 'when the topic is valid' do
    it 'persists the topic to the database' do
      subject.call topic

      expect(topic).to be_persisted
    end

    it 'persists the topic to the filesystem' do
      expect(Repository::Create).to receive(:call).with topic

      subject.call topic
    end

    it 'creates appropriate notifications' do
      expect(Notifications::CreateTopic).to receive(:call).with topic

      subject.call topic
    end
  end

  context 'when the topic is invalid' do
    let(:topic) { build :topic, :user => nil }

    it 'does not persist the topic to the database' do
      expect(topic).not_to be_persisted

      subject.call topic
    end

    it 'does not persist to the filesystem' do
      expect(Repository::Create).not_to receive :new

      subject.call topic
    end

    it 'does not create any notifications' do
      expect(Notifications::CreateTopic).not_to receive :call

      subject.call topic
    end

    describe 'return value' do
      subject { described_class.call topic }

      it { is_expected.to be_instance_of Topic }
      it { is_expected.not_to be_valid }
    end
  end
end
