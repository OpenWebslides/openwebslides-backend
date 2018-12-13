# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::CreateWorker do
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
  it 'persists the topic to the filesystem' do
    expect(Repository::Create).to receive(:call).with topic

    subject.perform topic.id
  end

  it 'creates appropriate notifications' do
    expect(Notifications::CreateTopic).to receive(:call).with topic

    subject.perform topic.id
  end
end
