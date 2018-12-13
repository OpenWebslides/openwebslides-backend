# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topics::ForkWorker do
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
  let(:fork) { create :topic, :upstream => topic, :root_content_item_id => topic.root_content_item_id }

  ##
  # Stubs and mocks
  #
  ##
  # Tests
  #
  before { Repository::Create.call topic }

  it 'persists the topic to the filesystem' do
    expect(Repository::Fork).to receive(:call).with topic, fork

    subject.perform topic.id, fork.id
  end

  it 'creates appropriate notifications' do
    expect(Notifications::ForkTopic).to receive(:call).with fork

    subject.perform topic.id, fork.id
  end
end
