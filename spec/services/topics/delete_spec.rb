# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Delete do
  ##
  # Configuration
  #
  ##
  # Test variables
  #
  let(:topic) { create :topic }

  ##
  # Subject
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Delete
  end

  ##
  # Tests
  #
  it 'destroys the topic in the database' do
    subject.call topic

    expect(topic).to be_destroyed
  end

  it 'deletes the topic in the filesystem' do
    dbl = double 'Repository::Delete'

    expect(Repository::Delete).to receive(:new)
      .with(instance_of Topic)
      .and_return dbl
    expect(dbl).to receive :execute

    subject.call topic
  end

  describe 'return value' do
    subject { described_class.call topic }

    it { is_expected.to be_instance_of Topic }
    it { is_expected.to be_valid }
  end
end
