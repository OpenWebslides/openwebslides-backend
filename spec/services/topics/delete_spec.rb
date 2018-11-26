# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Delete do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # described_class
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repository::Create.call topic }

  it 'destroys the topic in the database' do
    described_class.call topic

    expect(topic).to be_destroyed
  end

  it 'deletes the topic in the filesystem' do
    expect(Repository::Delete).to receive(:call).with topic

    described_class.call topic
  end

  describe 'return value' do
    subject { described_class.call topic }

    it { is_expected.to be_instance_of Topic }
    it { is_expected.to be_valid }
  end
end
