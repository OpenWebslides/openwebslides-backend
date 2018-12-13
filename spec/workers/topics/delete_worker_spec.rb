# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::DeleteWorker do
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
  let(:topic) { create :topic }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repository::Create.call topic }

  it 'destroys the topic in the database' do
    subject.perform topic.id

    expect { topic.reload }.to raise_error ActiveRecord::RecordNotFound
  end

  it 'deletes the topic in the filesystem' do
    expect(Repository::Delete).to receive(:call).with topic

    subject.perform topic.id
  end
end
