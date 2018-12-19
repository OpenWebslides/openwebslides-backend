# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::UpdateContent do
  ##
  # Configuration
  #
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
  it 'writes the content to a file' do
    subject.call topic, content, user, message
  end

  it 'dispatches a background job' do
    expect(Topics::UpdateContentWorker).to receive(:perform_async).with topic.id, an_instance_of(String), user.id, message

    subject.call topic, content, user, message
  end
end
