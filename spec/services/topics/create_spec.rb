# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Create do
  ##
  # Configuration
  #
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

    it 'dispatches a background job' do
      expect(Topics::CreateWorker).to receive(:perform_async).with an_instance_of Integer

      subject.call topic
    end
  end

  context 'when the topic is invalid' do
    let(:topic) { build :topic, :user => nil }

    it 'does not persist the topic to the database' do
      expect(topic).not_to be_persisted

      subject.call topic
    end

    it 'does not dispatch a background job' do
      expect(Topics::CreateWorker).not_to receive :perform_async

      subject.call topic
    end

    describe 'return value' do
      subject { described_class.call topic }

      it { is_expected.to be_instance_of Topic }
      it { is_expected.not_to be_valid }
    end
  end
end
