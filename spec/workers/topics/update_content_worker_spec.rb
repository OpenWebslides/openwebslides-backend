# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::UpdateContentWorker do
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
  let(:user) { create :user }
  let(:content) { ['content'] }
  let(:message) { 'This is a message' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repository::Create.call topic }

  it 'updates the content in the filesystem' do
    expect(Repository::Update).to receive(:call).with topic, content, user, message

    subject.perform topic.id, content, user.id, message
  end

  it 'creates appropriate notifications' do
    allow(Repository::Update).to receive(:call)
    expect(Notifications::UpdateTopic).to receive(:call).with topic, user

    subject.perform topic.id, content, user.id, message
  end
end
