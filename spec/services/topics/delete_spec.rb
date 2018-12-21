# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::Delete do
  ##
  # Configuration
  #
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
  it 'dispatches a background job' do
    expect(Topics::DeleteWorker).to receive(:perform_async).with an_instance_of Integer

    subject.call topic
  end
end
