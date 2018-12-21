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
  let(:topic) { create :topic }
  let(:user) { create :user }
  let(:content) { build :content }
  let(:message) { 'This is a message' }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Topics::Create.call topic }

  it 'dispatches a background job' do
    expect(Topics::UpdateContentWorker).to receive(:perform_async).with topic.id, an_instance_of(String), user.id, message

    subject.call topic, content.content, user, message
  end
end
