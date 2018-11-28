# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::UpdateContent do
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
  let(:user) { build :user }
  let(:content) { ['content'] }
  let(:message) { 'This is a message' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  it 'persists the topic to the filesystem' do
    expect(Repository::Update).to receive(:call).with topic, content, user, message

    subject.call topic, content, user, message
  end

  it 'creates appropriate notifications' do
    allow(Repository::Update).to receive :call
    expect(Notifications::UpdateTopic).to receive(:call).with topic, user

    subject.call topic, content, user, message
  end
end
