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
  describe 'the forked topic' do
    it 'destroys the topic' do
      subject.call topic

      expect(topic).to be_destroyed
    end

    it 'calls Repository::Delete' do
      dbl = double 'Repository::Delete'

      expect(Repository::Delete).to receive(:new)
        .with(instance_of Topic)
        .and_return dbl
      expect(dbl).to receive :execute

      subject.call topic
    end
  end
end
