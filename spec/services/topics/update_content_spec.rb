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
  it 'dispatches a background job' do
    expect(Topics::UpdateContentWorker).to receive(:perform_async).with topic.id, content, user.id, message

    subject.call topic, content, user, message
  end
end
